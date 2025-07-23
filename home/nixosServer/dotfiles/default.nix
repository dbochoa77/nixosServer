{
  inputs, 
  ...
}:

# Neovim Configuration
{
home.file.".config/nvim" = { 
    source = "${inputs.dotfiles}/nvim";
    recursive = true;
  };
}
