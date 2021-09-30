## DGP：

$$
Y(1)=x_1x_2 + \bf{x}^T\beta + \varepsilon_1\\
$$

$$
Y(0)=x_1x_2 + \varepsilon_2
$$

$$
M(1)=x_5x_6 + \bf{x}^T\gamma + \varepsilon_3
$$

$$
M(0)=x_5x_6 + \varepsilon_4\\
$$

where $\beta=(2,1,-1,2,0,...,0)$, $\gamma=(1,2,-2,-1,0,...,0)$, $\varepsilon_j\sim N(0,0.5^2)$.

$N_E=N_U=100$, $p=300$.

## Result：

$$
\begin{align}
\sqrt{N_{E}}\left(\begin{matrix}
    \hat{\bf{\beta}}_G-\bf{\beta}^0_G \\
    \hat{\bf{\gamma}}_G-\hat{\bf{\gamma}}_{E,G}
    \end{matrix}\right) \rightarrow 
     N\left(0,\left(\begin{matrix}
    \Sigma_{E}& \Sigma_{\rho}^T \\
    \Sigma_{\rho} & \Sigma_{M}
    \end{matrix}\right)\right)=
    N\left(0,\left(\begin{matrix}
    342.5& 37.5 \\
    37.5 & 16.5
    \end{matrix}\right)\right),
\end{align}
$$


P-value of ${{N_E}^{1/2}{\hat\Sigma_E}^{-1/2}\hat\beta}$ is 0.082.


$$
\tilde\beta_G = \hat\beta_G - \hat\Sigma_{\rho}^T\hat\Sigma_M^{-1}(\hat\gamma_G-\hat\gamma_{E,G}).
$$
P-value of ${{N_E}^{1/2}{(\hat\Sigma_E-\hat\Sigma_\rho^T\hat\Sigma_M^{-1}\hat\Sigma_\rho)}^{-1/2}\tilde\beta}$ is 0.080.

