// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

use std::env;
use std::path::{PathBuf};
use args;

#[derive(Debug)]
pub struct Config {
    pub root: PathBuf,
    pub tools: PathBuf,
    pub cake_version: String,
    pub script: Option<PathBuf>,
    pub nuget_version: Option<String>,
    pub sdk_version: Option<String>,
    pub use_coreclr: bool,
    pub bootstrap: bool,
    pub remaining: Vec<String>,
}

impl Config {
    pub fn new(args: &args::Arguments) -> Self {

        // Get the absolute script path.
        let script = match args.script.as_ref() {
            "" => Some(env::current_dir().unwrap().join("build.cake")),
            _ => Some(PathBuf::from(args.script.clone()))
        };

        // Get other paths.
        let root = get_script_root(&script);
        let tools = root.join("tools");

        return Config {
            root,
            tools,
            cake_version: create_option(&args.cake, false).unwrap_or("latest".to_string()),
            script,
            nuget_version: create_option(&args.nuget, true),
            sdk_version: create_option(&args.sdk, true),
            use_coreclr: args.coreclr,
            bootstrap: args.bootstrap,
            remaining: args.arguments.clone()
        };
    }

    pub fn should_install_nuget(&self) -> bool {
        return match self.nuget_version {
            None => false, 
            _ => true
        }
    }

    pub fn get_cake_package_name(&self, version: &String) -> String {
        if self.use_coreclr {
            return format!("cake.coreclr.{}.nupkg", version);
        }
        return format!("cake.{}.nupkg", version);
    }
}

fn create_option(value: &String, prefix: bool) -> Option<String> {
    return match value.as_ref() {
        "" => None,
        "latest" => Some("latest".to_string()),
        _ => {
            if prefix {
                return Some(format!("v{}", value.clone()));
            }
            return Some(value.clone());
        }
    };
}

fn get_script_root(script: &Option<PathBuf>) -> PathBuf {
    match script {
        &None => return env::current_dir().unwrap(),
        &Some(ref path) => {
            if path.is_relative() {
                return env::current_dir().unwrap();
            }
            return path.parent().unwrap().to_path_buf();
        }
    };
}