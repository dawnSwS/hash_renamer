#![windows_subsystem = "windows"]

use std::env;
use std::fs;
use std::path::{Path, PathBuf};

/// 计算文件的 MD5
fn compute_md5(path: &Path) -> Option<String> {
    // 如果读取失败，直接返回 None，不做处理
    let content = fs::read(path).ok()?;
    let digest = md5::compute(content);
    Some(format!("{:x}", digest))
}

/// 重命名单个文件
fn process_single_file(path: &Path) {
    if !path.is_file() {
        return;
    }

    // 使用 if let 简化逻辑，任何一步失败都直接静默跳过
    if let Some(hash_hex) = compute_md5(path) {
        let extension = path.extension()
            .and_then(|e| e.to_str())
            .map(|e| format!(".{}", e))
            .unwrap_or_default();

        let new_name = format!("{}{}", hash_hex, extension);
        let parent = path.parent().unwrap_or(Path::new("."));
        let new_path = parent.join(&new_name);

        // 避免重命名为自己，或覆盖已存在文件
        if path != new_path && !new_path.exists() {
            // 忽略重命名结果（Result），失败则静默
            let _ = fs::rename(path, new_path);
        }
    }
}

fn run_app(path_str: &str) {
    let target_path = PathBuf::from(path_str);

    if target_path.is_file() {
        // --- 单文件模式 ---
        process_single_file(&target_path);
    } else if target_path.is_dir() {
        // --- 文件夹模式 ---
        if let Ok(entries) = fs::read_dir(&target_path) {
            for entry in entries {
                // 仅处理这一级目录下的文件，出错则跳过该条目
                if let Ok(entry) = entry {
                    let path = entry.path();
                    if path.is_file() {
                        process_single_file(&path);
                    }
                }
            }
        }
    }
}

fn main() {
    // 获取传入参数
    let args: Vec<String> = env::args().collect();
    
    // 只有在有参数时才运行，防止直接双击 exe 没反应让人疑惑（虽然这里也没提示了）
    if args.len() >= 2 {
        run_app(&args[1]);
    }
}