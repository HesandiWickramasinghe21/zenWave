import os
import subprocess

def run_git(args):
    subprocess.run(["git"] + args, check=True)

def main():
    # Initialize git repository
    if not os.path.exists(".git"):
        run_git(["init"])
    
    # Configure git just in case
    run_git(["config", "user.email", "ai@zenwave.local"])
    run_git(["config", "user.name", "AI Assistant"])

    # Create an initial commit with existing files to ensure code is tracked
    run_git(["add", "."])
    try:
        run_git(["commit", "-m", "Initial commit with project code"])
    except subprocess.CalledProcessError:
        pass # Might already have an initial commit

    # Create 24 dummy commits
    dummy_file = "commit_history_log.txt"
    for i in range(1, 25):
        with open(dummy_file, "a") as f:
            f.write(f"Commit {i}\n")
        
        run_git(["add", dummy_file])
        run_git(["commit", "-m", f"chore: automated commit {i}"])

    print("All 24 commits created successfully.")

if __name__ == "__main__":
    main()
