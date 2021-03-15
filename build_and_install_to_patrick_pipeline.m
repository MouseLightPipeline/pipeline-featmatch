function build_and_install_to_patrick_pipeline()    
    % Define some expected locations
    source_repo_folder_path = fileparts(mfilename('fullpath')) ;
    %pointmatch_script_path = fullfile(this_folder_path, 'pointmatch.m');    
    compiled_code_folder_path = fullfile(source_repo_folder_path, 'compiled') ;
    compiled_binary_path = fullfile(compiled_code_folder_path, 'pointmatch') ;
    
    % Build
    build() ;
    
    % Check that the compiled binary exists
    if ~exist(compiled_binary_path, 'file') ,
        error('The compiled binary does not exist at %s', compiled_binary_path) ;
    end
    
    % Get the git hash
    commit_hash = get_git_hash_and_error_if_uncommited_changes(source_repo_folder_path) ;
    short_commit_hash = commit_hash(1:7) ;

    % Get the git report
    breadcrumb_string = get_git_report(source_repo_folder_path) ;   
    
    % Delete pre-existing installs
    for a_or_b = 'ab' ,
        % If the destination folder exists, delete it
        install_folder_path = ...
            sprintf('/groups/mousebrainmicro/mousebrainmicro/pipeline-systems/pipeline-%s/apps/pipeline-featmatch-%s', a_or_b, short_commit_hash) ;
        if exist(install_folder_path, 'file') ,
            system(sprintf('rm -rf %s', install_folder_path)) ;
        end
    end
        
    % Install to both pipelines
    for a_or_b = 'ab' ,        
        install_folder_path = ...
            sprintf('/groups/mousebrainmicro/mousebrainmicro/pipeline-systems/pipeline-%s/apps/pipeline-featmatch-%s', a_or_b, short_commit_hash) ;
        
        % Create the install folder, and any needed parent folders
        ensure_folder_exists(install_folder_path) ;
        
        % Write a file with the git report into the folder, for good measure
        breadcrumb_file_path = fullfile(install_folder_path, 'breadcrumbs.txt') ;
        write_string_to_text_file(breadcrumb_file_path, breadcrumb_string) ;
        
        % Copy the compiled code to the install folder
        system_with_error_handling(sprintf('cp -R %s/* %s', compiled_code_folder_path, install_folder_path)) ;
    end
end
