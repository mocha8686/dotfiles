{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      name = "Ichika";
      # url = "https://colorfulstage.com/upload_images/media/Download/Ichika%20Cursor%20animation.zip";
      # hash = "sha256-MZcQLNbSmpJKCvLNYjSYDfsOo4ZZNJdJagvEg6oZjZ4=";
      url = "https://colorfulstage.com/upload_images/media/Download/Ichika%20Cursor%20static.zip";
      hash = "sha256-dHTdmSYFuRYsEOwUe+RcZEu3gNE1A5eGGaX216FmPTY=";
      converts = {
        "Alternate" = "all-scroll";
        "Busy" = "wait";
        "Diagonal1" = "bottom_right_corner";
        "Diagonal2" = "bottom_left_corner";
        "Handwriting" = "pencil";
        "Help" = "question_arrow";
        "Horizontal" = "sb_h_double_arrow";
        "Link" = "link";
        "Move" = "move";
        "Normal" = "left_ptr";
        "Precision" = "cross";
        "Text" = "vertical-text";
        "Unavailable" = "X_cursor";
        "Vertical" = "sb_v_double_arrow";
        "Working" = "left_ptr_watch";
      };
      subs = {
        "X_cursor" = [
          "crossed_circle"
          "dnd_no_drop"
          "pirate"
          "x-cursor"
        ];
        "all-scroll" = [
          "fleur"
          "size_all"
        ];
        "bottom_left_corner" = [
          "fcf1c3c7cd4491d801f1e1c78f100000"
          "fd_double_arrow"
          "ll_angle"
          "ne-resize"
          "nesw-resize"
          "size_bdiag"
          "sw-resize"
          "top_right_corner"
          "ur_angle"
        ];
        "bottom_right_corner" = [
          "bd_double_arrow"
          "c7088f0f3e6c8088236ef8e1e3e70000"
          "lr_angle"
          "nw-resize"
          "nwse-resize"
          "se-resize"
          "size_fdiag"
          "top_left_corner"
          "ul_angle"
        ];
        "copy" = [
          "1081e37283d90000800003c07f3ef6bf"
          "6407b0e94181790501fd1e167b474872"
          "b66166c04f8c3109214a4fbd64a50fc8"
          "dnd-copy"
        ];
        "cross" = [
          "center_ptr"
          "color-picker"
          "cross_reverse"
          "crosshair"
          "diamond_cross"
          "dotbox"
          "plus"
          "tcross"
          "zoom-in"
          "zoom-out"
        ];
        "crossed_circle" = [
          "03b6e0fcb3499374a867c041f52298f0"
          "circle"
          "forbidden"
          "not-allowed"
        ];
        "dnd_no_drop" = [ "no-drop" ];
        "dotbox" = [
          "dot_box_mask"
          "draped_box"
          "icon"
          "target"
        ];
        "hand1" = [
          "grab"
          "openhand"
        ];
        "hand2" = [
          "9d800788f1b08800ae810202380a0822"
          "e29285e634086352946a0e7090d73106"
          "pointer"
          "pointing_hand"
          "arrow"
        ];
        "left_ptr" = [
          "default"
          "right_ptr"
          "top_left_arrow"
        ];
        "left_ptr_watch" = [
          "00000000000000020006000e7e9ffc3f"
          "08e8e1c95fe2fc01f976f1e063a24ccd"
          "3ecb610c1bf2410f44200f48c40d3599"
          "progress"
        ];
        "left_side" = [
          "e-resize"
          "right_side"
          "w-resize"
        ];
        "link" = [
          "3085a0e285430894940527032f8b26df"
          "640fb0e74195791501fd1ed57b41487f"
          "a2a266d0498c3104214a47bd64ab0fc8"
          "alias"
          "copy"
          "dnd-link"
          "hand1"
          "hand2"
        ];
        "move" = [
          "4498f0e0c1937ffe01fd06f973665830"
          "9081237383d90e509aa00f00170e968f"
          "closedhand"
          "dnd-move"
          "dnd-none"
          "fcf21c00b30f7e3f83fe0dfd12e71cff"
          "grabbing"
          "pointer_move"
        ];
        "pencil" = [ "draft" ];
        "plus" = [ "cell" ];
        "question_arrow" = [
          "5c6cd98b3f3ebcb1f9c7f1c204630408"
          "context-menu"
          "d9ce0ab605698f320427677b458ad60b"
          "dnd-ask"
          "help"
          "left_ptr_help"
          "whats_this"
        ];
        "right_ptr" = [
          "draft_large"
          "draft_small"
        ];
        "sb_down_arrow" = [ "down-arrow" ];
        "sb_h_double_arrow" = [
          "028006030e0e7ebffc7f7070c0600140"
          "14fef782d02440884392942c1120523"
          "col-resize"
          "ew-resize"
          "h_double_arrow"
          "left_side"
          "left_tee"
          "right_tee"
          "sb_left_arrow"
          "sb_right_arrow"
          "size-hor"
          "size_hor"
          "split_h"
        ];
        "sb_left_arrow" = [ "left-arrow" ];
        "sb_right_arrow" = [ "right-arrow" ];
        "sb_up_arrow" = [ "up-arrow" ];
        "sb_v_double_arrow" = [
          "00008160000006810000408080010102"
          "2870a09082c103050810ffdffffe0204"
          "bottom_tee"
          "double_arrow"
          "ns-resize"
          "row-resize"
          "sb_down_arrow"
          "sb_up_arrow"
          "size-ver"
          "size_ver"
          "split_v"
          "top_side"
          "top_tee"
          "v_double_arrow"
        ];
        "top_side" = [
          "bottom_side"
          "n-resize"
          "s-resize"
        ];
        "wait" = [
          "watch"
          "wayland-cursor"
        ];
        "vertical-text" = [
          "sibeam"
          "text"
          "xterm"
        ];
      };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = self.packages.${system}.ichikaCursor;

        packages.ichikaCursor = pkgs.stdenvNoCC.mkDerivation {
          name = "ichika-cursor";
          dontConfigure = true;
          src = pkgs.fetchzip {
            inherit url hash;
            stripRoot = false;
          };
          buildInputs = with pkgs; [
            win2xcur
          ];
          installPhase =
            let
              convert =
                from: to:
                "win2xcur \"${from}.cur\" && mv \"${from}\" \"$out/share/icons/${name}/cursors/${to}\"";
              sub =
                from: tos: builtins.concatStringsSep "\n" (builtins.map (to: "ln -sn \"$out/share/icons/${name}/cursors/${from}\" \"$out/share/icons/${name}/cursors/${to}\"") tos);
              flatten = attrSet: builtins.concatStringsSep "\n" (builtins.attrValues attrSet);
            in
            ''
              mkdir -p $out/share/icons/${name}/cursors

              ${flatten (builtins.mapAttrs convert converts)}

              ${flatten (builtins.mapAttrs sub subs)}

              cat <<-EOF >$out/share/icons/${name}/index.theme
              [Icon Theme]
              Name=Ichika
              Comment=Ichika XCursor theme
              Inherits="hicolor"
              EOF

              cat <<-EOF >$out/share/icons/${name}/cursor.theme
              Name=Ichika
              Inherits="Ichika"
              EOF
            '';
          meta.description = "Ichika cursor.";
        };
      }
    );
}
