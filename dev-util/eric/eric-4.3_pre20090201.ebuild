# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
NEED_PYTHON=2.4

inherit python eutils

MY_PN=${PN}4
MY_PV=${PV/_pre/-snapshot-}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="A full featured Python IDE that is written in PyQt4 using the QScintilla editor widget"
HOMEPAGE="http://eric-ide.python-projects.org/"
SRC_URI="mirror://sourceforge/eric-ide/${MY_P}.tar.gz
	linguas_cs? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-cs-${MY_PV}.tar.gz )
	linguas_de? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-de-${MY_PV}.tar.gz )
	linguas_es? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-es-${MY_PV}.tar.gz )
	linguas_fr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-fr-${MY_PV}.tar.gz )
	linguas_ru? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-ru-${MY_PV}.tar.gz )
	linguas_tr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-tr-${MY_PV}.tar.gz )
	linguas_zh? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-zh_CN.GB2312-${MY_PV}.tar.gz )"

SLOT="4"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="linguas_cs linguas_de linguas_es linguas_fr linguas_ru linguas_tr linguas_zh"

DEPEND="dev-python/PyQt4
	>=dev-python/qscintilla-python-2.2[qt4]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

LANGS="cs de es fr ru tr zh"

python_version

src_prepare() {
	epatch "${FILESDIR}"/4.3-paths.patch
	epatch "${FILESDIR}"/4.2.3-no-interactive.patch
}

src_install() {
	# Change qt dir to be located in ${D}
	dodir /usr/share/qt4/
	${python} install.py \
		-z \
		-b "/usr/bin" \
		-i "${D}" \
		-d "/usr/$(get_libdir)/python${PYVER}/site-packages" \
		-c || die "python install.py failed"

	make_desktop_entry "eric4 --nosplash" \
			eric4 \
			"/usr/$(get_libdir)/python${PYVER}/site-packages/eric4/icons/default/eric.png" \
			"Development;IDE;Qt"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/eric4{,plugins}
	elog "If you want to use eric4 with mod_python, have a look at"
	elog "\"${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/eric4/patch_modpython.py\"."
	elog
	elog "The following packages will give eric extended functionality."
	elog
	elog "dev-python/pylint"
	elog "dev-python/pysvn            (in sunrise overlay atm)"
	elog
	elog "This version has a new plugin interface with plugin-autofetch from"
	elog "the App itself. You may want to check those as well"
}

pkg_postrm() {
	python_mod_cleanup
}
