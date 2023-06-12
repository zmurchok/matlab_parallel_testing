gridSize = 25;
parpool('local',4);

mu = linspace(100, 150, gridSize);
nu = linspace(0.5, 2, gridSize);
[M,N] = meshgrid(mu,nu);

Z = nan(size(N));
c = surf(M, N, Z);
xlabel('\mu Values','Interpreter','Tex')
ylabel('\nu Values','Interpreter','Tex')
zlabel('Mean Period of  y')
view(137, 30)
axis([100 150 0.5 2 0 500]);

D = parallel.pool.DataQueue;
D.afterEach(@(x) updateSurface(c, x));

parfor ii = 1:numel(N)
    [t, y] = solveVdp(M(ii), N(ii));
    l = islocalmax(y(:, 2));
    send(D, [ii mean(diff(t(l)))]);
end
