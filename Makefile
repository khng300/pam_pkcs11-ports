# Created by: Ka Ho Ng <khng300@gmail.com>
# $FreeBSD$

PORTNAME=	pam_pkcs11
PORTVERSION=	0.6.11
CATEGORIES=	security
GH_ACCOUNT=	OpenSC
USE_GITHUB=     yes
GH_TAGNAME=	${PORTNAME}-${PORTVERSION}

MAINTAINER=	khng300@gmail.com
COMMENT=	PAM module using crypto tokens for auth

LICENSE=	LGPL21

USES=		autoreconf gmake libtool pkgconfig ssl

OPTIONS_DEFINE=		DEBUG DOCS CURL LDAP NLS PCSC
OPTIONS_DEFAULT=	NLS PCSC

GNU_CONFIGURE=	yes

CONFIGURE_ENV=	OPENSSL_CFLAGS="-I${OPENSSLINC}" \
		OPENSSL_LIBS="-L${OPENSSLLIB} -lcrypto"

CURL_LIB_DEPENDS=	libcurl.so:ftp/curl
CURL_CONFIGURE_WITH=	curl

LDAP_USE=		OPENLDAP=yes
LDAP_CONFIGURE_WITH=	ldap

PCSC_DESC=		Enable PC/SC support
PCSC_LIB_DEPENDS=	libpcsclite.so:devel/pcsc-lite
PCSC_CONFIGURE_WITH=	pcsclite

NLS_CONFIGURE_ENABLE=	nls
NLS_USES=	gettext
NLS_PLIST_FILES=share/locale/de/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/pt_BR/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/ru/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/it/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/tr/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/pl/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/fr/LC_MESSAGES/pam_pkcs11.mo \
		share/locale/nl/LC_MESSAGES/pam_pkcs11.mo

DOCS_CONFIGURE_ENABLE=	doc

PORTDOCS=	*

.include <bsd.port.options.mk>

.if ! ${PORT_OPTIONS:MDEBUG}
INSTALL_TARGET=		install-strip
.else
CONFIGURE_ARGS+=	--with-debug=yes
.endif

.if ${PORT_OPTIONS:MDOCS}
BUILD_DEPENDS+=	xsltproc:textproc/libxslt \
		${LOCALBASE}/share/xsl/docbook/html/docbook.xsl:textproc/docbook-xsl
CONFIGURE_ENV+=	XSLTPROC="${LOCALBASE}/bin/xsltproc"
CONFIGURE_ARGS+=--with-xsl-stylesheetsdir=${LOCALBASE}/share/xsl/docbook
.else
CONFIGURE_ENV+=	XSLTPROC="${FALSE}"
CONFIGURE_ARGS+=--without-xsl-stylesheetsdir
.endif

pre-configure:
	echo ${WRKDIR}
	@(cd ${WRKDIR}/pam_pkcs11-pam_pkcs11-${PORTVERSION} && ./bootstrap)

.include <bsd.port.mk>
