% Author: Rodrigo Rosário
% Modified: Eduardo Peixoto
%   E-mail: eduardopeixoto@ieee.org
function ptcld = slices2Ptcld(geoCube, axis)

%determina o eixo de recuperação
axis_table = ['x','y','z'];
%coordenada = find(axis_table == axis);

%Erro se o input for invalido
if (~any(axis_table == axis))
    error('Coordenada invalida');
end

nVoxels = sum(geoCube(:));
ptcld   = zeros(nVoxels,3,'single');
i = 1;

%varre todos os cortes
for k=1:size(geoCube,3)
    %encontra onde temos pixel
    [row,col] = find(geoCube(:,:,k)==1); 
    
    %m = 0;
    %m(1:length(row),1) = k;
    if (isempty(row) == 0)
        m = zeros(size(row)) + k;
        
        if (axis == 'x')
            currPoints = [m-1 row-1 col-1];
        elseif (axis == 'y')
            currPoints = [row-1 m-1 col-1];
        elseif (axis == 'z')
            currPoints = [row-1 col-1 m-1];
        else
            error('The axis should be x, y or z.');
        end
        
        for j = 1:1:size(currPoints,1)
            ptcld(i,:) = currPoints(j,:);
            i = i + 1;
        end
    end
end
     