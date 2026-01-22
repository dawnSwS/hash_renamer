#![windows_subsystem = "windows"]

use rayon::prelude::*;
use std::env;
use std::fs::{self, File};
use std::io::{BufReader, Read};
use std::path::{Path, PathBuf};

/// 优化：流式计算文件的 MD5
/// 优点：内存占用极低（固定 8KB），支持超大文件（如 10GB 视频）
fn compute_md5(path: &Path) -> Option<String> {
    let file = File::open(path).ok()?;
    let mut reader = BufReader::new(file);
    let mut context = md5::Context::new();
    let mut buffer = [0; 8192]; // 8KB 缓冲区

    loop {
        match reader.read(&mut buffer) {
            Ok(0) => break, // 读取结束
            Ok(n) => context.consume(&buffer[..n]),
            Err(_) => return None,
        }
    }

    let digest = context.compute();
    Some(format!("{:x}", digest))
}

/// 重命名单个文件逻辑
fn process_single_file(path: &Path) {
    // 安全性检查：跳过非文件或符号链接(防止死循环)
    if !path.is_file() || path.is_symlink() {
        return;
    }

    if let Some(hash_hex) = compute_md5(path) {
        let extension = path
            .extension()
            .and_then(|e| e.to_str())
            .map(|e| format!(".{}", e))
            .unwrap_or_default();

        let new_name = format!("{}{}", hash_hex, extension);
        let parent = path.parent().unwrap_or_else(|| Path::new("."));
        let new_path = parent.join(&new_name);

        // 避免重命名为自己，或覆盖已存在文件
        if path != new_path && !new_path.exists() {
            let _ = fs::rename(path, new_path);
        }
    }
}

fn run_app(path_str: &str) {
    // 路径清洗：Windows 注册表传参有时会带引号，需去除
    let clean_path = path_str.trim_matches('"');
    let target_path = PathBuf::from(clean_path);

    if target_path.is_file() {
        // --- 单文件模式 ---
        process_single_file(&target_path);
    } else if target_path.is_dir() {
        // --- 文件夹模式 (并行优化) ---
        if let Ok(entries) = fs::read_dir(&target_path) {
            // 使用 Rayon 将迭代器转换为并行流，利用多核 CPU 加速
            entries.par_bridge().for_each(|entry| {
                if let Ok(entry) = entry {
                    let path = entry.path();
                    // 仅处理当前层级的文件
                    if path.is_file() {
                        process_single_file(&path);
                    }
                }
            });
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    
    // 只有在有参数时才运行
    if args.len() >= 2 {
        run_app(&args[1]);
    }
}