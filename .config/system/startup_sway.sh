USE_NVIDIA=${1}

if [ "${USE_NVIDIA}" = "true" ]; then
  export __GL_GSYNC_ALLOWED=0
  export __GL_VRR_ALLOWED=0
  export WLR_DRM_NO_ATOMIC=1
  export GBM_BACKEND=nvidia-drm
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export WLR_NO_HARDWARE_CURSORS=1
  export WLR_DRM_DEVICES=/dev/dri/card1
  export WLR_RENDERER=vulkan
else
  export WLR_DRM_DEVICES=/dev/dri/card0
fi

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland
export XDG_CURRENT_DESKTOP=sway
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_PICTURES_DIR=$HOME/Screenshots

systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-wlr
dbus-run-session sway --unsupported-gpu
