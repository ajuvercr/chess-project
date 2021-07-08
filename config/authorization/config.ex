alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.Accessibility.ByQuery, as: AccessByQuery
alias Acl.GraphSpec.Constraint.Resource.AllPredicates, as: AllPredicates
alias Acl.GraphSpec.Constraint.Resource.NoPredicates, as: NoPredicates
alias Acl.GraphSpec.Constraint.ResourceFormat, as: ResourceFormatConstraint
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    # These elements are walked from top to bottom.  Each of them may
    # alter the quads to which the current query applies.  Quads are
    # represented in three sections: current_source_quads,
    # removed_source_quads, new_quads.  The quads may be calculated in
    # many ways.  The useage of a GroupSpec and GraphCleanup are
    # common.
    [
      %GroupSpec{
        name: "public",
        useage: [:write, :read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                          "http://schema.org/name",
                          "http://schema.org/description",
                          "http://schema.org/Band",
                          "http://schema.org/Song",
                          "http://schema.org/Game",
                          "http://schema.org/Move"
                      ]
                    } } ] },

      %GroupSpec{
        name: "user-lookup",
        useage: [:write, :read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                  graph: "http://mu.semte.ch/users",
                  constraint: %ResourceConstraint{
                    predicates: %AllPredicates{
                      except: [
                        "http://xmlns.com/foaf/0.1/accountName"
                      ] } }
                } ] },


      # // CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end
