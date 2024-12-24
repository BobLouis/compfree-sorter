
cd sim

# ncverilog -f pre_sim.f
vcs -R ../src/testfixture.v -v ../src/Sorter.v +access+r +vcs+fsdbon +fsdb+mda +fsdbfile+Sorter_pre.fsdb +notimingcheck +define+P3

cd ..