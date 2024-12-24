
cd sim

# ncverilog -f post_sim.f
vcs -R ../src/testfixture.v ../syn/n32_N128/Sorter_syn_7j80_1n18.v -v ../../../tsmc090_neg.v +access+r +vcs+fsdbon +fsdb+mda +fsdbfile+Sorter_post.fsdb +define+SDF +define+P1

cd ..