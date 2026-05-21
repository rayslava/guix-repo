;; btop.scm — btop 1.4.7 with GPU support enabled when the host has an
;; NVIDIA driver loaded. The libnvidia-ml.so.1 path is resolved at
;; recipe-eval time from a list of common host locations, then exposed
;; via the standard wrap-program — no custom shell scripting.

(use-modules
 (guix packages)
 (guix git-download)
 (guix build-system cmake)
 (guix gexp)
 ((guix licenses) #:prefix license:)
 (gnu packages admin)
 (gnu packages bash)
 (gnu packages markup)
 (srfi srfi-1))

(define %nvml-search-paths
  '("/usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1"
    "/usr/lib64/libnvidia-ml.so.1"
    "/usr/lib/libnvidia-ml.so.1"
    "/run/opengl-driver/lib/libnvidia-ml.so.1"
    "/run/current-system/profile/lib/libnvidia-ml.so.1"))

(define host-nvml
  (and (file-exists? "/proc/driver/nvidia")
       (find file-exists? %nvml-search-paths)))

(define-public btop-gpu
  (package
   (inherit btop)
   (name (if host-nvml "btop-gpu" "btop-next"))
   (version "1.4.7")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/aristocratos/btop")
                  (commit (string-append "v" version))))
            (file-name (git-file-name "btop" version))
            (sha256
             (base32
              "0d3cr5l6gpcwhxgnrizny5b5kg6fys2hy9a58bc68w4n2hc040fy"))))
   (build-system cmake-build-system)
   (arguments
    (list #:tests? #f
          #:configure-flags
          #~(list #$(if host-nvml "-DBTOP_GPU=ON" "-DBTOP_GPU=OFF")
                  "-DCMAKE_BUILD_TYPE=Release")
          #:phases
          (if host-nvml
              #~(modify-phases %standard-phases
                  (add-after 'install 'wrap-nvml
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (dir (string-append out "/share/btop-gpu/nvml")))
                        (mkdir-p dir)
                        (symlink #$host-nvml
                                 (string-append dir "/libnvidia-ml.so.1"))
                        (symlink #$host-nvml
                                 (string-append dir "/libnvidia-ml.so"))
                        (wrap-program (string-append out "/bin/btop")
                          `("LD_LIBRARY_PATH" prefix (,dir)))))))
              #~%standard-phases)))
   (inputs (if host-nvml (list bash-minimal) '()))
   (native-inputs (list lowdown))))

btop-gpu
