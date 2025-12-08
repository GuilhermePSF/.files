{
  shellAliases = {
    # --- System & Misc ---
    q = "exit";
    c = "clear";
    nv = "nvim";
    firefox = "firefox developer-edition";
    files = "nautilus . > /dev/null & disown";
    diskusage = "gdu";
    birth = "stat / | grep 'Birth' | sed 's/Birth: //g' | cut -b 2-11";
    brt = "xrandr --output eDP-1 --brightness";
    timestamp = "date -u +\"%Y%m%d%H%M%S\"";
    
    # --- Fixes / Utils ---
    history = "history 1";
    h = "history";
    kb = "setxkbmap us";
    df = "df -h -x tmpfs";
    nosuspend = "xset s off & xset -dpms";
    brave = "brave-browser";

    # --- Eza (Better ls) ---
    ls = "eza --color=always --group-directories-first --icons";
    ll = "eza -la --icons --octal-permissions --group-directories-first";
    l = "eza -bGF --header --git --color=always --group-directories-first --icons";
    llm = "eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons";
    la = "eza --long --all --group --group-directories-first";
    lx = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons";
    lS = "eza -1 --color=always --group-directories-first --icons";
    lt = "eza --tree --level=2 --color=always --group-directories-first --icons";

    # --- Git ---
    gs = "git status";
    ga = "git add";
    gaa = "git add .";
    gc = "git commit -m";
    gcm = "git commit";
    gca = "git commit --amend";
    gco = "git checkout";
    gb = "git branch";
    gbd = "git branch -d";
    gcl = "git clone";
    gpl = "git pull";
    gp = "git push";
    gpf = "git push --force";
    gpo = "git push origin";
    gplo = "git pull origin";
    gl = "git log --oneline --graph --all";
    glo = "git log --oneline";
    gstash = "git stash";
    gstashp = "git stash pop";
    gdiff = "git diff";
    gclean = "git clean -fd";
    grs = "git restore";
    grss = "git restore --staged";
    gwip = "git commit -m 'WIP'";
    guncommit = "git reset --soft HEAD~1 && grss .";
    gh = "git log --pretty=oneline --abbrev-commit";
    
    # --- Mix (Elixir) ---
    im = "iex -S mix";
    ims = "iex -S mix phx.server";
    mse = "mix setup";
    ms = "mix phx.server";
    mc = "mix check";
    mf = "mix format";
    ml = "mix lint";
    mt = "mix test";
    mdg = "mix deps.get";
    mdc = "mix deps.compile";
    mcom = "mix do clean, compile";
    mer = "mix ecto.reset";
    mem = "mix ecto.migrate";
    mes = "mix ecto.setup";
    mee = "mix ecto.seed";
    mec = "mix ecto.create";
    med = "mix ecto.drop";
    mni = "cd assets && ni && cd ..";

    # --- NPM ---
    # These work because 'nodejs' in default.nix provides 'npm'
    nr = "npm run";
    ns = "npm start";
    nd = "npm run dev";
    nb = "npm run build";
    nf = "npm run format";
    nfix = "npm run format:fix";
    nt = "npm run test";
    ni = "npm install";

    # --- Yarn ---
    # These work because 'yarn' in default.nix provides 'yarn'
    yr = "yarn run";
    ys = "yarn start";
    yd = "yarn run dev";
    yb = "yarn run build";
    yf = "yarn run format";
    yfix = "yarn run format:fix";
    yt = "yarn run test";
    yi = "yarn install";
    ya = "yarn add";

    # --- Bun ---
    # These work because 'bun' in default.nix provides 'bun'
    br = "bun run";
    bs = "bun run start";
    bd = "bun run dev";
    bb = "bun run build";
    bf = "bun run format";
    bfix = "bun run format:fix";
    bt = "bun run test";
    bi = "bun install";
    ba = "bun add";
  };
}
