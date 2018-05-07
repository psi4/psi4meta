def test_snsmp2():
    """snsmp2/he-he"""

    HeHe = psi4.geometry("""
    0 1
    He 0 0 0
    --
    He 2 0 0
    """)

    e = psi4.energy('sns-mp2')

    assert psi4.compare_values(0.00176708227, psi4.get_variable('SNS-MP2 TOTAL ENERGY'), 5, "SNS-MP2 IE [Eh]")
