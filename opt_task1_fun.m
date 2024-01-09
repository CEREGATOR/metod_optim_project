function [Ufact, Ucalc, error] = opt_task1_fun(file_path)

%% Reading data from file
fid = fopen(file_path,'rt');                                                % Path to data file
if fid ~= -1
    l = fgetl(fid);
    while ~strcmp(l, 'GRID')
        l = fgetl(fid);
    end    
    G = fscanf(fid, '%f');
    L = G(1); M = G(2); N = G(3);
    h = L/M; tau = 1; K = tau/(2*h^2);
    l = fgetl(fid);
    while ~strcmp(l, 'TUBE')
        l = fgetl(fid);
    end    
    a = transpose(fscanf(fid, '%f'));
    l = fgetl(fid);
    while ~strcmp(l, 'TEMP')
    l = fgetl(fid);
    end
    Uin = fscanf(fid, '%f');
    fclose(fid);

%% Arrays initialization
    Ufact = zeros(N, M);
    for i = 1:N
    Ufact(i, :) = Uin((M+1)*i-(M-1):(M+1)*i);                               % Mesuared temperature
    end

    fi1 = Ufact(:, 1);                                                      % Left boundary condition
    fi2 = Ufact(:, M);                                                      % Right boundary condition
    U0  = transpose(Ufact(1, :));                                           % Initial temperature

    Am = zeros(M, 1);
    Bm = zeros(M, 1);
    Cm = zeros(M, 1);
    Am(2:M-1) = -K.*( a(1:M-2) + a(2:M-1) );
    Bm(2:M-1) = 1 + K.*( ( a(1:M-2)+a(2:M-1) ) + ( a(2:M-1)+a(3:M) ) );     % Calculating coefficients for tridiagonal matrix
    Cm(2:M-1) = -K.*( a(2:M-1) + a(3:M) );                                  

    Sn = spdiags([[Am(2:M-1); 0; 0] Bm [0; 0; Cm(2:M-1)]], -1:1, M, M);     % Creating tridiagonal matrix
    Ucalc = zeros(N, M);                                                    % Preallocating array for calculated temperature
    Ucalc(1, :) = Ufact(1, :);                                              % Initial temperature we know

%% Solving system of linear equations
    b = U0;
    for i = 1:N-1
        Sn(1, 1) = b(1)/fi1(i+1);
        Sn(M, M) = b(M)/fi2(i+1);
        x = Sn\b;
        Ucalc(i+1, :) = x;
        b = x;
    end

%% Error calculation
    Error = (Ucalc( Ufact ~= -1 ) - Ufact( Ufact ~= -1 )).^2;               % Using logical indexing for excluding -1 for error calculation
    error = sum(Error(:));
else
    fprintf("Can't open file!\n");
end    

end