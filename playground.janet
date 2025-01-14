(import spork/path)

(defn build-fmt-image []
  (def env (require "spork/fmt"))
  (spit "fmt.jimage" (make-image env)))

(defn build 
  ```
  Build wasm module. Needs emsdk to be installed and activated
  ```
  []
  (def build-folder-info (os/stat "build"))

  (when (nil? build-folder-info) (os/mkdir "build"))
  (os/cd "build")
  (build-fmt-image)

  (def result
    (try
      (do
        (os/execute
          @["emcc" "-O2" "-o" "janet.js"
            (path/join ".." "janet" "janet.c")
            (path/join ".." "janet" "play.c")
            (string "-I" (path/join ".." "janet"))
            "--embed-file" "fmt.jimage"
            "-s" "EXPORTED_FUNCTIONS=['_run_janet']"
            "-s" "ALLOW_MEMORY_GROWTH=1"
            "-s" "AGGRESSIVE_VARIABLE_ELIMINATION=1"
            "-s" "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']" ]
          :p))
      ([err] (eprint "Failed to run emcc. Make sure that it's installed and emsdk has been activated"))))
  (unless (zero? result)
    (eprint "Error running emcc. Build failed.")))

(defn main [&] (build))






