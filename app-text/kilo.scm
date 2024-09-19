(define-module (kilo)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:select (bsd-2))
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages ncurses))

(define-public kilo
  (package
   (name "kilo")
   (version "2020-07-05")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/antirez/kilo")
                  (commit "69c3ce609d1e8df3956cba6db3d296a7cf3af3de")))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "09a6q6976pi5dmxcn2wv2nz1ngm5pa2sghgci8f24h619ilz6czb"))))
   (build-system gnu-build-system)
   (arguments
    `(#:make-flags (list "CC=gcc" (string-append "PREFIX=" (assoc-ref %outputs "out")))
		   #:phases
		   (modify-phases %standard-phases
				  (delete 'configure)
				  (delete 'check)
				  (replace 'install
					   (lambda* (#:key outputs #:allow-other-keys)
						    (let ((out (assoc-ref outputs "out")))
						      (install-file "kilo" (string-append out "/bin"))))))))
   (inputs
    `(("ncurses" ,ncurses)))
   (synopsis "A simple text editor in less than 1K lines of code")
   (description
    "Kilo is a simple text editor in less than 1K lines of code")
   (home-page "https://github.com/antirez/kilo")
   (license bsd-2)))
