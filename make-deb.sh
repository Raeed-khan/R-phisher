#!/bin/bash

# Make Deb Package for R-phisher 
_PACKAGE="r-phisher"
_VERSION="2.3.5"
_ARCH="all"

if [[ ${1,,} == "termux" || $(uname -o) == *'Android'* ]]; then
    _depend="ncurses-utils, proot, resolv-conf, "
    _bin_dir="data/data/com.termux/files/usr/bin"
    _opt_dir="data/data/com.termux/files/usr/opt/${_PACKAGE}"
    PKG_NAME="${_PACKAGE}_${_VERSION}_${_ARCH}_termux.deb"
else
    _bin_dir="usr/bin"
    _opt_dir="opt/${_PACKAGE}"
    PKG_NAME="${_PACKAGE}_${_VERSION}_${_ARCH}.deb"
fi

# Checking for main script instead of non-existent launch.sh
if [[ ! -e "R-phisher.sh" ]]; then
    echo "Error: R-phisher.sh not found in current directory. Exiting..."
    exit 1
fi

_depend+="curl, php, unzip"

# Clean build environment
if [[ -d "build_env" ]]; then 
    rm -fr build_env
fi

mkdir -p "./build_env/${_bin_dir}" "./build_env/${_opt_dir}" "./build_env/DEBIAN"

# Generating DEBIAN control file with your info
cat <<- CONTROL_EOF > ./build_env/DEBIAN/control
Package: ${_PACKAGE}
Version: ${_VERSION}
Architecture: ${_ARCH}
Maintainer: @Raeed-khan
Depends: ${_depend}
Homepage: https://github.com/Raeed-khan/R-phisher
Description: An automated phishing tool with 30+ templates. This Tool is made for educational purpose only!
CONTROL_EOF

# Generating Pre-removal script
cat <<- PRERM_EOF > ./build_env/DEBIAN/prerm
#!/bin/bash
rm -fr /${_opt_dir}
rm -f /${_bin_dir}/${_PACKAGE}
exit 0
PRERM_EOF

# Setting permissions
chmod 755 ./build_env/DEBIAN
chmod 755 ./build_env/DEBIAN/control ./build_env/DEBIAN/prerm

# Copying core files to package directory
cp -fr .github/ .sites/ LICENSE README.md R-phisher.sh ./build_env/${_opt_dir}/

# Creating a symlink/launcher wrapper inside usr/bin
cat <<- LAUNCHER_EOF > ./build_env/${_bin_dir}/${_PACKAGE}
#!/bin/bash
cd /${_opt_dir} && bash R-phisher.sh "\$@"
LAUNCHER_EOF

chmod 755 "./build_env/${_bin_dir}/${_PACKAGE}"

# Building the Debian package
echo "Building package: ${PKG_NAME}..."
dpkg-deb --build ./build_env "${PKG_NAME}"

# Clean up
rm -fr ./build_env
echo "Package build completed successfully!"
