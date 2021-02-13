function install_to_patrick_pipeline(a_or_b)
    % Check args
    if isequal(a_or_b, 'a') || isequal(a_or_b, 'b') ,
        % all is well
    else
        error('First argument must be ''a'' or ''b'', to indicate which pipeline to install to') ;
    end
    
    % Define some expected locations
    this_folder_path = fileparts(mfilename('fullpath')) ;
    %pointmatch_script_path = fullfile(this_folder_path, 'pointmatch.m');    
    compiled_code_folder_path = fullfile(this_folder_path, 'compiled') ;
    compiled_binary_path = fullfile(compiled_code_folder_path, 'pointmatch') ;
    
    % Check that the compiled binary exists
    if ~exist(compiled_binary_path, 'file') ,
        error('The compiled binary does not exist at %s', compiled_binary_path) ;
    end

    % Get the git hash
    commit_hash = get_git_hash_and_error_if_uncommited_changes(this_folder_path) ;
    short_commit_hash = commit_hash(1:7) ;

    % If the destination folder exists, error out
    install_folder_path = ...
      sprintf('/groups/mousebrainmicro/mousebrainmicro/pipeline-systems/pipeline-%s/apps/pipeline-featmatch-%s', a_or_b, short_commit_hash) ;
    if exist(install_folder_path, 'file') ,
        error('Install folder %s already exists, please move or delete before installing new one') ;
    end
    
    % Create the install folder, and any needed parent folders
    ensure_folder_exists(install_folder_path) ;
    
    % Copy the compiled code to the install folder
    system_with_error_handling(sprintf('cp -R %s/* %s', compiled_code_folder_path, install_folder_path)) ;
    
    % Write a file with the commit hash into the folder, for good measure
    commit_hash_file_path = fullfile(install_folder_path, 'commit-hash.txt') ;
    write_string_to_text_file(commit_hash_file_path, commit_hash) ;    
end
