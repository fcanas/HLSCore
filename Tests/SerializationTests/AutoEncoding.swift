//
//  AutoEncoding.swift
//  ParsingTests
//
//  Created by Fabián Cañas on 12/27/18.
//

import XCTest
// Here we test public behavior. We shouldn't import the module as testable
// because visibility is part of our contract.
import Serialization
import Types
import Parsing

class AutoEncoding: XCTestCase {

    func testMediaPlaylist() {
        let playlist =
        """
        #EXTM3U
        #EXT-X-TARGETDURATION:6
        #EXT-X-VERSION:7
        #EXT-X-MEDIA-SEQUENCE:1
        #EXT-X-PLAYLIST-TYPE:VOD
        #EXT-X-INDEPENDENT-SEGMENTS
        #EXT-X-MAP:URI="main.mp4",BYTERANGE="720@0"
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:540482@720
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551488@541202
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549405@1092690
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551782@1642095
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548996@2193877
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549160@2742873
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550953@3292033
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549499@3842986
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551123@4392485
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550296@4943608
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548446@5493904
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552205@6042350
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549949@6594555
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552062@7144504
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548345@7696566
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548046@8244911
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549915@8792957
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549905@9342872
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550852@9892777
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550464@10443629
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550749@10994093
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549749@11544842
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548235@12094591
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551026@12642826
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549459@13193852
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549475@13743311
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551571@14292786
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549220@14844357
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:553879@15393577
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551318@15947456
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550114@16498774
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548555@17048888
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548237@17597443
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549431@18145680
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550584@18695111
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551212@19245695
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548992@19796907
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549999@20345899
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549927@20895898
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550652@21445825
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550410@21996477
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551015@22546887
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549605@23097902
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552853@23647507
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550513@24200360
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551360@24750873
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551846@25302233
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548689@25854079
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549432@26402768
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548816@26952200
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552351@27501016
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552291@28053367
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550550@28605658
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552528@29156208
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551020@29708736
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550283@30259756
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552273@30810039
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549643@31362312
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550361@31911955
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549987@32462316
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549423@33012303
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551090@33561726
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550027@34112816
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552846@34662843
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550031@35215689
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549515@35765720
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551206@36315235
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551986@36866441
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:553570@37418427
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550846@37971997
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549565@38522843
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550589@39072408
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549628@39622997
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:553471@40172625
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551277@40726096
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548932@41277373
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549599@41826305
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:547857@42375904
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549411@42923761
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548882@43473172
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549596@44022054
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552280@44571650
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550035@45123930
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552248@45673965
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:550139@46226213
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:548887@46776352
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549391@47325239
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551518@47874630
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552012@48426148
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549835@48978160
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551578@49527995
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552680@50079573
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549329@50632253
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:549482@51181582
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:551513@51731064
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552357@52282577
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:553546@52834934
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:552617@53388480
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:553716@53941097
        main.mp4
        #EXTINF:6.0,
        #EXT-X-BYTERANGE:555409@54494813
        main.mp4\n
        """
        let url = URL(string: "https://www.example.com/media.m3u8")!

        let parsed = parseMediaPlaylist(string: playlist, atURL:url)!

        let rebuilt = MediaPlaylistSerializer().serialize(parsed).value!

        AssertMatchMultilineString(playlist, rebuilt, separator: "\n")
    }

}
