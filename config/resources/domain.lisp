(in-package :mu-cl-resources)

(define-resource song ()
  :class (s-prefix "schema:Song")
  :properties `((:title :string ,(s-prefix "foaf:name"))
                (:rating :decimal ,(s-prefix "foaf:price")))
  :has-one `((band :via ,(s-prefix "schema:Band")
                    :as "band"))
  :resource-base (s-url "http://mu.semte.ch/services/github/madnificent/book-service/songs/")
  :on-path "songs")


(define-resource band ()
  :class (s-prefix "schema:Band")
  :properties `((:name :string ,(s-prefix "schema:name"))
                (:description :string ,(s-prefix "schema:description")))
  :has-many `((song :via ,(s-prefix "schema:Band")
                      :inverse t
                      :as "songs"))
  :resource-base (s-url "http://mu.semte.ch/services/github/madnificent/book-service/bands/")
  :on-path "bands")
