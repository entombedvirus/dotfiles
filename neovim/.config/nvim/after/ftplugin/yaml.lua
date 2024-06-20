vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.wo.foldmethod = 'indent'
-- don't automatically ident on # and :
vim.opt_local.indentkeys:remove({ '0#', '<:>' })
