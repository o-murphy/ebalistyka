Name:           ebalistyka
Version:        VERSION_PLACEHOLDER
Release:        RELEASE_PLACEHOLDER%{?dist}
Summary:        Ballistic trajectory calculator
License:        GPL-3.0
URL:            https://github.com/o-murphy/ebalistyka-app
BuildArch:      ARCH_PLACEHOLDER
AutoReq:        no
Requires:       gtk3, glib2

%description
A cross-platform ballistic trajectory calculator built with Flutter.
Powered by bclibc — a high-performance C++ ballistic solver engine
with RK4/Euler integration and spin drift support.

%install
cp -a %{_sourcedir}/. %{buildroot}/

%files
/opt/ebalistyka/
/usr/bin/ebalistyka
/usr/share/applications/io.github.o_murphy.ebalistyka.desktop
/usr/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png
/usr/share/metainfo/io.github.o_murphy.ebalistyka.metainfo.xml

%changelog
