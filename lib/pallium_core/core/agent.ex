defmodule PalliumCore.Core.Agent do
  # MerklePatriciaTree.Trie.empty_trie_root_hash()
  @empty_trie_root_hash <<86, 232, 31, 23, 27, 204, 85, 166, 255, 131, 69, 230, 146, 192, 248,
                          110, 91, 72, 224, 27, 153, 108, 173, 192, 1, 98, 47, 181, 227, 99, 180,
                          33>>

  use PalliumCore.Struct,
    nonce: 0,
    balance: 0,
    state: @empty_trie_root_hash,
    code: "",
    key: ""
end
