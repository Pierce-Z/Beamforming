


factor = Fc / 1.8e9;
patch_lgh = 75e-3 / factor;
patch_wdt = 75e-3 / factor;
patch_hgt = 6e-3  / factor;
feed_ofs  = [-0.0187 0] / factor;

pm = patchMicrostrip('Length',patch_lgh, 'Width',patch_wdt, 'height' , patch_hgt, 'feedoffset', feed_ofs, ...
        'GroundPlaneLength',patch_lgh * 2 , 'GroundPlaneWidth',patch_wdt * 2 );
    

    
% URA_array = phased.URA('Size' , [ant_x , ant_y] , 'ElementSpacing' , [0.5 * lambda 0.5 * lambda] , 'Lattice','Triangular' , 'ArrayNormal' , 'x');
% URA_array = phased.URA('Element' , pm , 'Size' , [ant_x , ant_y] , 'ElementSpacing' , [0.5 * lambda 0.5 * lambda] , 'Lattice','Triangular' , 'ArrayNormal' , 'z');
% URA_array = phased.ULA('Element' , pm , 'NumElements' , ant_y , 'ElementSpacing' , 0.5 * lambda , 'ArrayAxis' , 'y');
elemt_pos = zeros(3 , ant_x * ant_y); 

elemt_pos(1 , :) = repmat(0.5 * lambda * (0 : ant_y -1) , 1 , ant_x); % x-axis
elemt_pos(2 , :) = reshape(repmat(0.5 * lambda * (0 : ant_x -1) ,  ant_y , 1) , 1 , ant_x * ant_y );% y-axis
URA_array = phased.ConformalArray( 'Element' , pm , 'ElementPosition', elemt_pos , 'ElementNormal' , [90 * ones(1,ant_y * ant_x) ; 0 * ones(1,  ant_x * ant_y)]);
