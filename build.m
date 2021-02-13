function build()
    this_folder_path = fileparts(mfilename('fullpath')) ;
    pointmatch_script_path = fullfile(this_folder_path, 'pointmatch.m');    
    functions_folder_path = fullfile(this_folder_path, 'functions');    
    %compiled_function_binary_path = '/groups/mousebrainmicro/home/base/CODE/MATLAB/compiledfunctions/pointmatch/pointmatch';
    compiled_code_folder_path = fullfile(this_folder_path, 'compiled') ;
    compiled_binary_path = fullfile(compiled_code_folder_path, 'pointmatch') ;
    if exist(compiled_code_folder_path, 'file') ,
        return_code = system(sprintf('rm -rf %s', compiled_code_folder_path)) ;
        if return_code ~= 0 ,
            error('Unable to delete existing compiled code folder %s', compiled_code_folder_path) ;
        end
    end
    
    mkdir(compiled_code_folder_path);
    % unix(sprintf('mcc -m -v -R -singleCompThread %s -d %s -a %s',mfilename_,compiled_function_folder_path,fullfile(fileparts(mfilename_),'functions')))
    %command_line = sprintf('mcc -m -v %s -d %s -a %s',pointmatch_script_path,compiled_function_folder_path,functions_folder_path) ;
    %system(command_line) ;
    mcc('-m', '-v', pointmatch_script_path, '-d', compiled_code_folder_path, '-a', functions_folder_path) ;
    command_line = sprintf('chmod g+x %s',compiled_binary_path) ;
    return_code = system(command_line) ;
    if return_code ~= 0 ,
        error('Unable make compiled binary %s group-executable', compiled_binary_path) ;
    end    
end
