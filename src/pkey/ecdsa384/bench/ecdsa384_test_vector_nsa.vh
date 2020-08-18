/* Values from "Suite B Implementer's Guide to FIPS 186-3 (ECDSA)" */

localparam [383:0] ECDSA_P384_D_NSA =
    {32'hc838b852, 32'h53ef8dc7, 32'h394fa580, 32'h8a518398,
	 32'h1c7deef5, 32'ha69ba8f4, 32'hf2117ffe, 32'ha39cfcd9,
	 32'h0e95f6cb, 32'hc854abac, 32'hab701d50, 32'hc1f3cf24};

localparam [383:0] ECDSA_P384_QX_NSA =
	{32'h1fbac8ee, 32'hbd0cbf35, 32'h640b39ef, 32'he0808dd7,
	 32'h74debff2, 32'h0a2a329e, 32'h91713baf, 32'h7d7f3c3e,
	 32'h81546d88, 32'h3730bee7, 32'he48678f8, 32'h57b02ca0};
	 
localparam [383:0] ECDSA_P384_QY_NSA =
	{32'heb213103, 32'hbd68ce34, 32'h3365a8a4, 32'hc3d4555f,
	 32'ha385f533, 32'h0203bdd7, 32'h6ffad1f3, 32'haffb9575,
	 32'h1c132007, 32'he1b24035, 32'h3cb0a4cf, 32'h1693bdf9};
	 
localparam [383:0] ECDSA_P384_K_NSA =
	{32'hdc6b4403, 32'h6989a196, 32'he39d1cda, 32'hc000812f,
	 32'h4bdd8b2d, 32'hb41bb33a, 32'hf5137258, 32'h5ebd1db6,
	 32'h3f0ce827, 32'h5aa1fd45, 32'he2d2a735, 32'hf8749359};

localparam [383:0] ECDSA_P384_RX_NSA =
	{32'ha0c27ec8, 32'h93092dea, 32'h1e1bd2cc, 32'hfed3cf94,
	 32'h5c8134ed, 32'h0c9f8131, 32'h1a0f4a05, 32'h942db8db,
	 32'hed8dd59f, 32'h267471d5, 32'h462aa14f, 32'he72de856};
	 
localparam [383:0] ECDSA_P384_RY_NSA =
	{32'h85564940, 32'h9815bb91, 32'h424eaca5, 32'hfd76c973,
	 32'h75d575d1, 32'h422ec53d, 32'h343bd33b, 32'h847fdf0c,
	 32'h11569685, 32'hb528ab25, 32'h49301542, 32'h8d7cf72b};
