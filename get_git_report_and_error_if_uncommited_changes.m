function breadcrumb_string = get_git_report_and_error_if_uncommited_changes(source_repo_folder_path)
    original_pwd = pwd() ;
    cleaner = onCleanup(@()(cd(original_pwd))) ;
    cd(source_repo_folder_path) ;
    
    % Make sure the git remote is up-to-date
    system_with_error_handling('git remote update') ;    
    
    % Get the git hash
    stdout = system_with_error_handling('git status --porcelain=v1') ;
    trimmed_stdout = strtrim(stdout) ;  % Will be empty if no uncomitted changes
    if ~isempty(trimmed_stdout) ,
        error('The git repo seems to have uncommitted changes:\n%s', stdout) ;
    end
    stdout = system_with_error_handling('git rev-parse --verify HEAD') ;
    commit_hash = strtrim(stdout) ;

    % Get the git remote report
    git_remote_report = system_with_error_handling('git remote -v') ;    
    
    % Get the git status
    git_status = system_with_error_handling('git status') ;    
    
    % Get the recent git log
    git_log = system_with_error_handling('git log --graph --oneline --max-count 10 | cat') ;
        
    % Write a file with the commit hash into the folder, for good measure
    breadcrumb_string = sprintf('Source repo:\n%s\n\nCommit hash:\n%s\n\nRemote info:\n%s\n\nGit status:\n%s\n\nGit log:\n%s\n\n', ...
                                source_repo_folder_path, ...
                                commit_hash, ...
                                git_remote_report, ...
                                git_status, ...
                                git_log) ;
end
