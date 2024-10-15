(define-module (net-wireless qFlipper)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system qt)
  #:use-module ((guix licenses) #:select (gpl3)))

(define-public qFlipper
  (package
   (name "qFlipper")
   (version "1.3.3")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/flipperdevices/qFlipper.git")
           (commit version)
	   (recursive? #t)))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1rq0fbq904vjczvvbzyjkds8ghv2nsakj3i9jpa5ydilw3wg4z7x"))))
   (build-system qt-build-system)
   (arguments
    `(#:tests? #f
	       #:phases
	       (modify-phases %standard-phases
			      (replace 'configure
				       (lambda _
					 (invoke "qmake" "qFlipper.pro")))
			      (replace 'install
				       (lambda* (#:key outputs #:allow-other-keys)
					 (let ((out (assoc-ref outputs "out")))
					   (invoke "make" "install" (string-append "INSTALL_ROOT=" out))))))))
   (inputs
    (list qtbase-5 qttools-5 qtserialport-5 qtquickcontrols-5 qtquickcontrols2-5
	  qtsvg-5 qtdeclarative-5 libusb zlib))
   (native-inputs
    (list pkg-config git))
   (home-page "https://flipperzero.one/")
   (synopsis "Desktop application for Flipper Zero device management")
   (description
    "qFlipper is a desktop application designed to interact with the Flipper Zero
      multi-tool device. It enables firmware updates, managing applications, and
      various other device management features.")
   (license gpl3)))
