% init experimental environment
%
function env = init_env_v1_1l


env.N = 6;
env.S = 1:env.N;

env.A = 1:3;

% transitions T(s,a,s')
env.T = zeros(env.N, length(env.A), env.N);
env.T(1, 1, 2) = 1;
env.T(1, 2, 2) = 1;
env.T(2, 1, 3) = 1;
env.T(2, 2, 4) = 1;
env.T(2, 3, 5) = 1;
env.T(3, 1, 2) = 1;
env.T(4, 1, 2) = 1;
env.T(5, 1, 2) = 1;
env.T(3, 2, 6) = 1;
env.T(4, 2, 6) = 1;
env.T(5, 2, 6) = 1;
env.T(1, 3, 6) = 1; % this is a hack
env.T(3, 3, 6) = 1;
env.T(4, 3, 6) = 1;
env.T(5, 3, 6) = 1;

% features phi(s,a)
% TODO make random choices when indifferent; currently order matters b/c of ties
env.phi{1, 1} = [4 0];
env.phi{1, 2} = [0 2];
env.phi{2, 1} = [0 0]; 
env.phi{2, 2} = [0 0];
env.phi{2, 3} = [0 0];
env.phi{3, 1} = [0 0];
env.phi{4, 1} = [0 0];
env.phi{5, 1} = [0 0];
env.phi{3, 2} = [7 0];
env.phi{4, 2} = [4 6];
env.phi{5, 2} = [0 8];
env.phi{1, 3} = [-1000 -1000];
env.phi{3, 3} = [-1000 -1000];
env.phi{4, 3} = [-1000 -1000];
env.phi{5, 3} = [-1000 -1000];
env.phi{6, 1} = [0 0];
env.phi{6, 2} = [0 0];
env.phi{6, 3} = [0 0];

% terminal states
env.terminal = zeros(1, env.N);
env.terminal(6) = 1;