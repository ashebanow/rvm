# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

EGIT_REPO_URI="git://github.com/wayneeseguin/rvm.git"

DESCRIPTION="RVM facilitates easy installation and management of multiple Ruby environments and sets of gems"
HOMEPAGE="http://rvm.beginrescueend.com/"

SRC_URI=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="mono java"

RDEPEND="net-misc/curl
	sys-devel/patch
    java? (
        dev-java/sun-jdk
        dev-java/sun-jre-bin
    )
    mono? ( dev-lang/mono )"

RVM_DIR="/opt/rvm"

src_install() {
	for v in `env | egrep '^rvm_' | cut -d '=' -f 1`; do
		unset $v
	done
	export rvm_path="${D}${RVM_DIR}"
	export rvm_symlink_path="${D}/usr/bin"

	./install || die "Installation failed."

	echo "rvm_path=${RVM_DIR}" > "${T}"/rvmrc
	insinto /etc
	doins "${T}"/rvmrc || die "Failed to install /etc/rvmrc."
	elog "A default /etc/rvmrc has been installed.  Feel free to modify it."
	elog

	echo 'unset RUBY_VERSION' > "${T}"/system
	echo 'unset GEM_HOME' >> "${T}"/system
	echo 'unset GEM_PATH' >> "${T}"/system
	echo 'unset MY_RUBY_HOME' >> "${T}"/system
	insinto ${RVM_DIR}/config
	doins "${T}"/system || die "Failed to install ${RVM_DIR}/config/system."
	elog "You may also wish to review ${RVM_DIR}/config/system ."
	elog

	elog "Before any user (including root) can use rvm, the following line must be appended"
	elog "to the end of the user's shell's loading files (.bashrc and then .bash_profile"
	elog "for bash; or .zshrc for zsh), after all path/variable settings:"
	elog
	elog "     if [[ -s $RVM_DIR/scripts/rvm ]] ; then source $RVM_DIR/scripts/rvm ; fi"
}
