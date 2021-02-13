function result = get_git_hash_and_error_if_uncommited_changes(repo_path)
    original_pwd =pwd() ;
    cleaner = onCleanup(@()(cd(original_pwd))) ;
    cd(repo_path) ;
    stdout = system_with_error_handling('git status --porcelain=v1') ;
    tokens = strsplit(stdout) ;  % Will be empty if no uncomitted changes
    if ~isempty(tokens) ,
        error('The git repo seems to have uncommitted changes:\n%s', stdout) ;
    end
    stdout = system_with_error_handling('git rev-parse --verify HEAD') ;
    result = strtrim(stdout) ;
end
