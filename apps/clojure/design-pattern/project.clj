(defproject design-pattern "1.0.0"
  :description "Design Patterns in Clojure"
  :dependencies [[org.clojure/clojure "1.12.0"]]
  :main ^:skip-aot design-pattern.core
  :target-path "target/%s"
  :plugins [[jonase/eastwood "1.4.3"]]
  :profiles {:uberjar {:aot :all}}
  :aliases {"check" ["do" ["eastwood"] ["test"]]})
