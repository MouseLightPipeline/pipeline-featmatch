function exitcode = pointmatch(tile1, tile2, acqusitionfolder1, acqusitionfolder2, output_folder_name, pixshift, ch, maxnumofdesc, exitcode)
    % Deal with arguments
    if ~exist('pixshift', 'var') || isempty(pixshift) ,
        pixshift = '[0 0 0]' ;
    end
    if ~exist('ch', 'var') || isempty(ch) ,
        ch = '1' ;
    end
    if ~exist('maxnumofdesc', 'var') || isempty(maxnumofdesc) ,
        maxnumofdesc=1e3 ;
    end
    if ~exist('exitcode', 'var') || isempty(exitcode) ,
        exitcode = 0 ;
    end
    
    % Eval args that are strings that we need to be numeric
    if ischar(pixshift)
        pixshift = eval(pixshift);
    end
    if ischar(ch) ,
        ch = eval(ch) ;
    end
    if ischar(maxnumofdesc)
        maxnumofdesc=str2double(maxnumofdesc);
    end
    if ischar(exitcode)
        exitcode=str2double(exitcode);
    end
    
    % Read in stuff from input files
    scopefile1 = readScopeFile(acqusitionfolder1);
    scopefile2 = readScopeFile(acqusitionfolder2);
    desc1 = readDesc(tile1, ch) ;
    desc2 = readDesc(tile2, ch) ;
    
    % Call the function that does the real work
    [paireddescriptor, iadj] = pointmatch_core(desc1, desc2, scopefile1, scopefile2, pixshift, maxnumofdesc) ;

    % Write the main output file
    tag = 'XYZ';
    output_file_name = fullfile(output_folder_name,sprintf('match-%s.mat',tag(iadj))); % append 1 if match found
    if exist(output_file_name,'file')
        unix(sprintf('rm -f %s',output_file_name)) ;
    end
    save(output_file_name,'paireddescriptor','scopefile1','scopefile2')
    system(sprintf('chmod g+rw %s',output_file_name));
    
    % Write a thumbnail image file
    X_ = paireddescriptor.X ;
    Y_ = paireddescriptor.Y ;
    % x:R, y:G, z:B
    if isempty(X_) ,
        col = [0 0 0] ;  % black as night
    else
        col = median(Y_-X_,1)+128;
    end    
    col = max(min(col,255),0);
    outpng = zeros(105,89,3);
    outpng(:,:,1) = col(1);
    outpng(:,:,2) = col(2);
    outpng(:,:,3) = col(3);
    thumbnail_image_file_name = fullfile(output_folder_name,'Thumbs.png') ;
    if exist(thumbnail_image_file_name,'file')
        system(sprintf('rm -f %s',thumbnail_image_file_name)) ;
    end
    imwrite(outpng,thumbnail_image_file_name)
    system(sprintf('chmod g+rw %s',thumbnail_image_file_name));
end
