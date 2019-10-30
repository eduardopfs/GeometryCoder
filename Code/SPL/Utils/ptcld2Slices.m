% Author: Rodrigo Rosário
% Modified: Eduardo Peixoto
%   E-mail: eduardopeixoto@ieee.org
function cortes = ptcld2Slices(ptcloud,eixo,lado)
%aumenta 1 nos lados para que seja de 1 ate lado+1 e nao 0 a lado
lado = lado+1;

%determina o eixo a ser cortado
tab_eixo = ['x','y','z'];
coordenada = find(tab_eixo == eixo);

%Erro se o input for invalido
if (~any(tab_eixo == eixo))
    error('Coordenada invalida');
end

%Estabelece os valores minimos de cada coordenada
loc = ptcloud;
loc = loc+1;
xmin = min(loc(:,1));
ymin = min(loc(:,2));
zmin = min(loc(:,3));

%define os limites possiveis
x = 1;
boundlimits = [];
for i = 1:10
    boundlimits = [boundlimits x x+lado-1];
    x = x+lado;
end
%realiza o shift para o centro do plano cartesiano
shiftx = boundlimits(xmin>=boundlimits);
shiftx = shiftx(end);
shifty = boundlimits(ymin>=boundlimits);
shifty = shifty(end);
shiftz = boundlimits(zmin>=boundlimits);
shiftz = shiftz(end);

loc(:,1) = loc(:,1)-shiftx;
loc(:,2) = loc(:,2)-shifty;
loc(:,3) = loc(:,3)-shiftz;

%organiza a ptcloud em ordem crescente do eixo escolhido
loc = loc+1;
loc = sortrows(loc,coordenada);
cont = loc(1,coordenada);

cortes = zeros(lado,lado,lado,'logical');
for x=(loc(1,coordenada):loc(length(loc),coordenada))
    %estabele as coordenadas para cada ponto fixo da coordenada 
    if (eixo == 'x')     f = loc(find(loc(:,coordenada)==x),2:3);     end
    if (eixo == 'y')     f = loc(find(loc(:,coordenada)==x),1:2:3);   end
    if (eixo == 'z')     f = loc(find(loc(:,coordenada)==x),1:2);     end

    %laço que varre todas as coordenadas de determinado eixo e marca como 1
    %na matriz G=ladoxlado
    g = zeros(lado,lado,'logical');
    for i = 1:size(f,1)
        g(f(i,1),f(i,2)) = 1;
    end
    
    %salva as imagens dos cortes transversais
    cortes(:,:,cont) = g;
    cont = cont+1;
    %imwrite(g, ['corte_' eixo '=' num2str(x) '.bmp']);
    
end
