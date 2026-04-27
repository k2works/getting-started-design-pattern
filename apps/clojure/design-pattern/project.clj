(defproject design-pattern "1.0.0"
  :description "Design Patterns in Clojure"
  :dependencies [[org.clojure/clojure "1.12.0"]]
  :main ^:skip-aot design-pattern.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
