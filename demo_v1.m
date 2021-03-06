clear all;

env = init_env_v1;
filename = 'demo_v1.mat';

w_train = {[1 0 0], [0 1 0]};
w_test = {[1 1 0], [0 0 1]};

for iter = 1:60

    [pi_test_UVFA, pi_test_SF, V, V_test, psi, Vmax, pi_test_MB, pi_test_MF] = simul(env, w_train, w_test);

    for t = 1:length(w_test)

        % test UVFA
        r = 0;
        s = 1;
        while true
            r = r + env.phi{s} * w_test{t}';
            if env.terminal(s)
                break
            end
            a = pi_test_UVFA{t}(s);
            s = find(mnrnd(1, squeeze(env.T(s, a, :))));
        end
        term(t, 1, iter) = s;
        tot_r(t, 1, iter) = r;

        % test SF 
        r = 0;
        s = 1;
        while true 
            r = r + env.phi{s} * w_test{t}';
            if env.terminal(s)
                break
            end
            a = pi_test_SF{t}(s);
            s = find(mnrnd(1, squeeze(env.T(s, a, :))));
        end
        term(t, 2, iter) = s;
        tot_r(t, 2, iter) = r;

        % test MB 
        r = 0;
        s = 1;
        while true 
            r = r + env.phi{s} * w_test{t}';
            if env.terminal(s)
                break
            end
            a = pi_test_MB{t}(s);
            s = find(mnrnd(1, squeeze(env.T(s, a, :))));
        end
        term(t, 3, iter) = s;
        tot_r(t, 3, iter) = r;

        % test MF 
        r = 0;
        s = 1;
        while true 
            r = r + env.phi{s} * w_test{t}';
            if env.terminal(s)
                break
            end
            a = pi_test_MF(s);
            s = find(mnrnd(1, squeeze(env.T(s, a, :))));
        end
        term(t, 4, iter) = s;
        tot_r(t, 4, iter) = r;
    end

end

save(filename);

figure;


%{

sem = @(x) std(x) / sqrt(length(x));

% plot performance on test tasks, fig for each test task
for t = 1:length(w_test)
    subplot(3, length(w_test), t);

    for i = 1:2
        r = squeeze(tot_r(t, i, :));
        m(i) = mean(r);
        se(i) = sem(r);
    end

    hold on;
    bar([1 2], m);
    errorbar([1 2], m, se, 'color', [0 0 0], 'linestyle', 'none');
    xticks([1 2]);
    xticklabels({'UVFA', 'SF'});
    ylabel('test reward');
    title(sprintf('test w = [%.0f %.0f %.0f]', w_test{t}));
end

% plot performance on test tasks, fig for each algo
labels = {};
for t = 1:length(w_test)
    labels{t} = sprintf('w = [%.0f %.0f %.0f]', w_test{t});
end
titles = {'UVFA', 'SF'};
for i = 1:2
    subplot(3, 2, 2 + i);

    for t = 1:length(w_test)
        r = squeeze(tot_r(t, i, :));
        m(t) = mean(r);
        se(t) = sem(r);
    end

    hold on;
    bar(m);
    errorbar(m, se, 'color', [0 0 0], 'linestyle', 'none');
    xticks(1:length(m));

    xticklabels(labels);
    xtickangle(40);
    ylabel('test reward');
    title(titles{i});
    xlabel('test task');
end

% plot MDP as graph
E = zeros(env.N, env.N);
for s = 1:env.N
    for s_new = 1:env.N
        if sum(squeeze(env.T(s,:,s_new))) > 0
            E(s, s_new) = 1;
        end
    end
end
G = digraph(E);

subplot(3, 1, 3);
h = plot(G);
for s = 1:env.N
    labelnode(h, s, sprintf('phi(%d) = [%.0f %.0f %.0f]', s, env.phi{s} * 10));
end
ylim([-0.5 4]);
xlim([0.5 11]);
set(gca, 'xtick', []);
set(gca, 'ytick', []);
xlabel('note: all features x 10 (for vizualization)');

%}



% TODO refactor, dedupe


figure;

sem = @(x) std(x) / sqrt(length(x));

% plot performance on test tasks, fig for each test task
for t = 1:length(w_test)
    subplot(3, length(w_test), t);

    clear m;
    clear se;
    for i = 1:4
        r = squeeze(tot_r(t, i, :));
        m(i) = mean(r);
        se(i) = sem(r);
    end

    hold on;
    bar([1:4], m);
    errorbar([1:4], m, se, 'color', [0 0 0], 'linestyle', 'none');
    xticks([1:4]);
    xticklabels({'UVFA', 'SF&GPI', 'MB', 'MF'});
    ylabel('test reward');
    title(sprintf('test w = [%.0f %.0f %.0f %.0f]', w_test{t}));
end

% plot performance on test tasks, fig for each algo
labels = {};
for t = 1:length(w_test)
    labels{t} = sprintf('w = [%.0f %.0f %.0f %.0f]', w_test{t});
end
titles = {'UVFA', 'SF&GPI', 'MB', 'MF'};
for i = 1:4
    subplot(3, 4, 4 + i);

    clear m;
    clear se;
    for t = 1:length(w_test)
        r = squeeze(tot_r(t, i, :));
        m(t) = mean(r);
        se(t) = sem(r);
    end

    hold on;
    bar(m);
    errorbar(m, se, 'color', [0 0 0], 'linestyle', 'none');
    xticks(1:length(m));

    xticklabels(labels);
    xtickangle(40);
    ylabel('test reward');
    title(titles{i});
    xlabel('test task');
end

% plot MDP as graph
E = zeros(env.N, env.N);
for s = 1:env.N
    for s_new = 1:env.N
        if sum(squeeze(env.T(s,:,s_new))) > 0
            E(s, s_new) = 1;
        end
    end
end
G = digraph(E);

subplot(3, 1, 3);
h = plot(G);
for s = 1:env.N
    labelnode(h, s, sprintf('phi(%d) = [%.0f %.0f %.0f %.0f]', s, env.phi{s} * 10));
end
ylim([-0.5 4]);
xlim([0.5 11]);
set(gca, 'xtick', []);
set(gca, 'ytick', []);
title('MDP');
xlabel('note: all features x 10 (for vizualization)');


% histogram of final test states
%

figure;

plot_idx = 0;
for i = 1:4

    for t = 1:length(w_test)
        
        cnt = [];
        for s = 5:13 % TODO hardcoded
            which = squeeze(term(t, i, :)) == s;
            cnt(s) = sum(which);
        end

        plot_idx = plot_idx + 1;
        subplot(4, length(w_test), plot_idx);

        bar(cnt);

        title(labels{t});
        xticks(5:13);
        xlim([4.5 13.5]);
        xlabel('final state');
        if t == 1
            ylabel(titles{i});
        end
    end
end
