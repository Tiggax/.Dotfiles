# Script file to aid when working in bioiformatics
# Test c

# Open Fasta files and load them into a table with <name> and <sequence> columns.
export def "from fasta" [
    ] {
    let input = $in
    if $input == null {
        error make --unspanned {msg: "You have no input"}
    }
    $input | parse -r '>(?<name>.+)\n(?<sequence>[acgtnATCGN\n]+)'
}
# Saves the table containing {name} and {sequence} into a fasta format
# The input table needs to have BOTH {name} and {sequence} columns.
export def "to fasta" [] {
    let input = $in
    if $input == null {
        error make --unspanned {msg: "You have no input"}
    }
    if ( $input.name == null and $input.sequence == null )  {
           error make {msg: "The table doesn't contain {name} or {sequence} columns"} 
        } 
    $input | format ">{name}\n{sequence}" | str join
}
# export module "to" {
#     export def fasta [] {
#         let input = $in
#         if $input == null {
#             error make --unspanned {msg: "You have no input"}
#         }
#         if ( $input.name == null and $input.sequence == null )  {
#             error make {msg: "The table doesn't contain {name} or {sequence} columns"} 
#         } 
#         $input | format ">{name}\n{sequence}" | str join
#     }
# }
