ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(RidesApi.Repo, :manual)

defmodule RidesApi.Test.Helper do
  alias RidesApi.{Shares.Car, Shares.Person}

  def insert(:all) do
    car_model_names = [
      "4Runner",
      "86",
      "Avalon",
      "Avalon Hybrid",
      "C-HR",
      "Camry",
      "Camry Hybrid",
      "Corolla",
      "Corolla iM",
      "Highlander",
      "Highlander Hybrid",
      "Land Cruiser",
      "Mirai",
      "Prius",
      "Prius c",
      "Prius Prime",
      "RAV4",
      "RAV4 Hybrid",
      "Sequoia",
      "Sienna",
      "Tacoma",
      "Tundra",
      "Yaris",
      "Yaris iA"
    ]

    anime_names =
      ~w(Ai Aika Aiko Aimi Aina Airi Akane Akemi Aki Akihiro Akiko Akio Akira Amaterasu Ami Aoi Arata Asami Asuka Atsuko Atsushi Aya Ayaka Ayako Ayame Ayane Ayano Ayumu Chie Chieko Chiharu Chika Chikako Chinatsu Chiyo Chiyoko Cho Chouko Dai Daichi Daiki Daisuke Eiji Eiko Emi Emiko Eri Etsuko Fumiko Fumio Gajeel Goro Hachiro Hajime Hana Hanako Haru Haruka Haruki Haruko Harumi Haruna Haruo Haruto Hayate Hayato Hibiki Hideaki Hideki Hideko Hideo Hideyoshi Hikari Hikaru Hina Hinata Hiraku Hiro Hiroaki Hiroki Hiroko Hiromi Hironori Hiroshi Hiroto Hiroyuki Hisako Hisao Hisashi Hisoka Hitomi Hitoshi Honoka Hoshi Hoshiko Hotaka Hotaru Ichiro Isamu Isao Itsuki Izumi Jiro Jun Junichi Junko Juro Kaede Kaito Kamiko Kanako Kanon Kaori Kaoru Kasumi Katashi Katsu Katsumi Katsuo Katsuro Kazue Kazuhiko Kazuhiro Kazuki Kazuko Kazumi Kazuo Kei Keiko Ken Kenichi Kenta Kichiro Kiko Kiku Kimi Kimiko Kin Kiyoko Kiyomi Kiyoshi Kohaku Kokoro Kotone Kouki Kouta Kumiko Kunio Kuro Kyo Kyoko Mio Misaki Mitsuko Mitsuo Mitsuru Miu Miwa Miyako Miyoko Miyu Miyuki Mizuki Moe Momoe Momoka Momoko Moriko Nana Nanami Nao Naoki Naoko Naomi Natsu Natsuki Natsuko Natsumi Noa Noboru Nobu Nobuko Nobuo Noburu Nobuyuki Nori Noriko Norio Osamu Ran Rei Reiko Ren Rie Rika Riko Riku Rikuto Rin Rina Rio Rokuro Ryo Ryoichi Ryoko Ryota Ryuu Ryuunosuke Saburo Sachiko Sadao Saki Sakura Sakurako Satoko Satomi Satoru Satoshi Sayuri Seiichi Seiji Setsuko Shichiro Shigeko Shigeo Shigeru Shika Shin Shinichi Shinji Shinju Shiori Shiro Shizuka Shizuko Sho Shoichi Shoji Shouta Shuichi Shuji Shun Sora Souta Sumiko Susumu Suzu Suzume Tadao Tadashi Taichi Taiki Takahiro Takako Takao Takara Takashi Takayuki Takehiko Takeo Takeshi Takuma Takumi Tamiko Tamotsu Taro Tatsuo Tatsuya Tetsuya Tomiko Tomio Tomohiro Tomoko Tomomi Toru Toshi Toshiaki Toshiko Toshio Toshiyuki Tsubaki Tsubame Tsukiko Tsuneo Tsutomu Tsuyoshi Ume Umeko Usagi Wakana Wendy Yamato Yasu Yasuko Yasuo Yasushi Yoichi Yoko Yori Yoshi Yoshiaki Yoshie Yoshikazu Yoshiko Yoshinori Yoshio Yoshiro Yoshito Yoshiyuki Youta Yua Yui Yuichi Yuina Yuji Yuka Yukari Yuki Yukiko Yukio Yuko Yumi Yumiko Yuri Yuriko Yutaka Yuu Yuudai Yuuki Yuuma Yuuna Yuuta Yuuto Yuzuki)

    # Normalize the lists into lists of the relevant structs
    c_list = car_model_names |> Enum.map(fn n -> %{name: "Toyota #{n}"} end)
    p_list = anime_names |> Enum.map(fn p -> %{name: p} end)

    c_list |> Enum.map(fn c -> {_a, _c} = Car.create(c) end)
    p_list |> Enum.map(fn p -> {_a, _p} = Person.create(p) end)
  end

  def insert(:car, name, size) when is_binary(name) and is_integer(size) do
    for n <- 1..size do
      # For increase larger n have a repeated pattern of n
      # So if n is 3 repeat the String "3", three times
      # Convert back to String

      suffix = Stream.cycle([n]) |> Enum.take(n) |> Enum.join()
      _ = Car.create(%{name: "#{name}#{suffix}"})
    end
  end
end
