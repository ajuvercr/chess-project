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



(define-resource move ()
  :class (s-prefix "schema:Move")
  :properties `((:fromx :number ,(s-prefix "schema:fromX") :required)
                (:fromy :number ,(s-prefix "schema:fromY") :required)
                (:tox :number ,(s-prefix "schema:toX") :required)
                (:toy :number ,(s-prefix "schema:toY") :required)
                (:slain :string ,(s-prefix "schema:slain")))
  :has-one `((game :via ,(s-prefix "schema:Game")
                      :as "game"))
  :resource-base (s-url "http://mu.semte.ch/services/github/madnificent/book-service/moves/")
  :on-path "moves")


(define-resource game ()
  :class (s-prefix "schema:Game")
  :properties `((:start :string ,(s-prefix "schema:Start") :required)
                (:white :string ,(s-prefix "schema:white"))
                (:black :string ,(s-prefix "schema:black")))
  :has-many `((move :via ,(s-prefix "schema:Game")
                      :inverse t
                      :as "moves"))
  :resource-base (s-url "http://mu.semte.ch/services/github/madnificent/book-service/games/")
  :on-path "games")
