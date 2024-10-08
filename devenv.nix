{ pkgs, ... }: {
  packages = [ pkgs.yarn ];

  scripts.build.exec = "yarn build";

  tasks = {
    "myapp:build".exec = "build";
    "devenv:enterShell".after = [ "myapp:build" ];
  };

  # Runs on `git commit` and `devenv test`
  pre-commit.hooks = {
    black.enable = true;
    # Your custom hooks
    generate-css = {
      enable = true;
      name = "generate-css";
      entry = "build";
    };
  };
}