(import circlet)
(import spork/path)

(defn wasm-stuffs [s] 
  (fn [arg] 
    (def ret (s arg))
    (def to-check (path/join "build" (arg :uri)))
    (pp (os/stat to-check))
    (if (and 
          (string/has-suffix? ".wasm" (arg :uri))
          (os/stat to-check))
      (do 
        (pp "TAKEN")
        { :kind :file :file to-check :mime "application/wasm" }
        )
      ret)))

(defn derp [s] 
  (fn [arg]
    (def ret (s arg))
    (pp ret)
    ret))

(defn main [&] 
  (circlet/server 
    (->
      {:default {:kind :static
                 :root "build"}}
      circlet/router
      circlet/logger
      wasm-stuffs
      derp
      )
    8000 "127.0.0.1"))
