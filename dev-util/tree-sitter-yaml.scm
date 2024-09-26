(define-module (dev-util tree-sitter-yaml)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:select (expat))
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages ncurses))

(define-public tree-sitter-yaml
  (package
   (name "tree-sitter-yaml")
   (version "0.6.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
                  (commit "v0.6.1")))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "1jx6a54cjn1xd5g5y9z44y2nnfs288g40bs3dbjzsf6x8x87l32z"))))
   (build-system gnu-build-system)
   (arguments
    `(#:make-flags (list "CC=gcc" (string-append "PREFIX=" (assoc-ref %outputs "out")))
		   #:phases
		   (modify-phases %standard-phases
				  (delete 'configure)
				  (delete 'check))))
   (synopsis "A tree-sitter parser for YAML files")
   (description
    "A tree-sitter parser for YAML files")
   (home-page "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
   (license expat)))
