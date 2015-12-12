function y = lorenz(~, p)

    sigma = 10.;
    rho = 28.;
    beta = 8./3.;

    A = [   
        -beta,  0,      p(2);
        0,      -sigma, sigma;
        -p(2),  rho,    -1
    ];

    y = A*p;

end