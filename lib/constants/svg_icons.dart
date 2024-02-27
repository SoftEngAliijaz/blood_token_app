import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGIcons extends StatelessWidget {
  const SVGIcons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSvgWithDivider("logos/001-blood_drop.svg", 1),
            _buildSvgWithDivider("logos/002-screen.svg", 2),
            _buildSvgWithDivider("logos/003-medical_kit.svg", 3),
            _buildSvgWithDivider("logos/004-clipboard.svg", 4),
            _buildSvgWithDivider("logos/005-blood_bag.svg", 5),
            _buildSvgWithDivider("logos/006-ambulance.svg", 6),
            _buildSvgWithDivider("logos/007-microscope.svg", 7),
            _buildSvgWithDivider("logos/008-blood_drop.svg", 8),
            _buildSvgWithDivider("logos/009-map_location.svg", 9),
            _buildSvgWithDivider("logos/010-test_tube.svg", 10),
            _buildSvgWithDivider("logos/011-dna.svg", 11),
            _buildSvgWithDivider("logos/012-mobile_phone.svg", 12),
            _buildSvgWithDivider("logos/013-blood_drop.svg", 13),
            _buildSvgWithDivider("logos/014-doctor.svg", 14),
            _buildSvgWithDivider("logos/015-blood_drop.svg", 15),
            _buildSvgWithDivider("logos/016-syringe.svg", 16),
            _buildSvgWithDivider("logos/017-blood_drop.svg", 17),
            _buildSvgWithDivider("logos/018-blood_tube.svg", 18),
            _buildSvgWithDivider("logos/019-hospital.svg", 19),
            _buildSvgWithDivider("logos/020-blood_drop.svg", 20),
            _buildSvgWithDivider("logos/021-red_blood_cells.svg", 21),
            _buildSvgWithDivider("logos/022-blood_donation.svg", 22),
            _buildSvgWithDivider("logos/023-blood_drop.svg", 23),
            _buildSvgWithDivider("logos/024-nurse.svg", 24),
            _buildSvgWithDivider("logos/025-donor.svg", 25),
            _buildSvgWithDivider("logos/026-map_pointer.svg", 26),
            _buildSvgWithDivider("logos/027-blood_drop.svg", 27),
            _buildSvgWithDivider("logos/028-blood_donor_card.svg", 28),
            _buildSvgWithDivider("logos/029-rubber_gloves.svg", 29),
            _buildSvgWithDivider("logos/030-syringe_needle.svg", 30),
            _buildSvgWithDivider("logos/031-blood_bank.svg", 31),
            _buildSvgWithDivider("logos/032-blood_bag.svg", 32),
            _buildSvgWithDivider("logos/033-blood_drop.svg", 33),
            _buildSvgWithDivider("logos/034-virus.svg", 34),
            _buildSvgWithDivider("logos/035-band_aid.svg", 35),
            _buildSvgWithDivider("logos/036-dentist_chair.svg", 36),
            _buildSvgWithDivider("logos/037-blood_drop.svg", 37),
            _buildSvgWithDivider("logos/038-stethoscope.svg", 38),
            _buildSvgWithDivider("logos/039-ribbon.svg", 39),
            _buildSvgWithDivider("logos/040-blood_bag.svg", 40),
            _buildSvgWithDivider("logos/041-blood_drop.svg", 41),
            _buildSvgWithDivider("logos/042-dropper.svg", 42),
            _buildSvgWithDivider("logos/043-shirt.svg", 43),
            _buildSvgWithDivider("logos/044-blood_drop.svg", 44),
            _buildSvgWithDivider("logos/045-blood_drop_empty.svg", 45),
            _buildSvgWithDivider("logos/logo.svg", 46),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgWithDivider(String assetName, int index) {
    return Column(
      children: [
        SvgPicture.asset("assets/$assetName"),
        const Divider(
          thickness: 1,
          color: Colors.black,
        ),
        Text("Index: $index"),
        const Divider(
          thickness: 1,
          color: Colors.black,
        ),
      ],
    );
  }
}
