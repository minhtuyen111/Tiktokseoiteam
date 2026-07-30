-- RedzHub - Auto Farm Level Only
-- Giữ: Auto Farm Level + Select Tool + tên menu + các hook chống Death/Respawn và anti-idle có trong source.
-- Đã bỏ các tab/chức năng khác.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false
_G.SelectWeapon = "Melee"
_G.NotAutoEquip = false
BypassTP = false


-- Giữ lại phần chống Death/Respawn có trong file gốc.
pcall(function()
    hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function()
        -- intentionally empty
    end)
    hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Respawn), function()
        -- intentionally empty
    end)
end)

if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    World3 = true
end

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

function CheckQuest()
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 or SelectMonster == "Bandit" then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, -0, 1, -0, 0.341998369, -0, 0.939700544)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        elseif (MyLevel < 10 or MyLevel > 14) and SelectMonster ~= "Monkey" then
            if (MyLevel < 15 or MyLevel > 29) and SelectMonster ~= "Gorilla" then
                if (MyLevel < 30 or MyLevel > 39) and SelectMonster ~= "Pirate" then
                    if (MyLevel < 40 or MyLevel > 59) and SelectMonster ~= "Brute" then
                        if MyLevel >= 60 and MyLevel <= 74 or SelectMonster == "Desert Bandit" then
                            Mon = "Desert Bandit"
                            LevelQuest = 1
                            NameQuest = "DesertQuest"
                            NameMon = "Desert Bandit"
                            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693)
                            CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
                        elseif (MyLevel < 75 or MyLevel > 89) and SelectMonster ~= "Desert Officer" then
                            if (MyLevel < 90 or MyLevel > 99) and SelectMonster ~= "Snow Bandit" then
                                if MyLevel >= 100 and MyLevel <= 119 or SelectMonster == "Snowman" then
                                    Mon = "Snowman"
                                    LevelQuest = 2
                                    NameQuest = "SnowQuest"
                                    NameMon = "Snowman"
                                    CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, -0, 0.939684391, -0, 1, -0, -0.939684391, -0, -0.342042685)
                                    CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
                                elseif (MyLevel < 120 or MyLevel > 149) and SelectMonster ~= "Chief Petty Officer" then
                                    if (MyLevel < 150 or MyLevel > 174) and SelectMonster ~= "Sky Bandit" then
                                        if (MyLevel < 175 or MyLevel > 189) and SelectMonster ~= "Dark Master" then
                                            if MyLevel >= 190 and MyLevel <= 209 or SelectMonster == "Prisoner" then
                                                Mon = "Prisoner"
                                                LevelQuest = 1
                                                NameQuest = "PrisonerQuest"
                                                NameMon = "Prisoner"
                                                CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918E-9, -0.995993316, 1.60817859E-9, 1, -5.16744869E-9, 0.995993316, -2.06384709E-9, -0.0894274712)
                                                CFrameMon = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)
                                            elseif (MyLevel < 210 or MyLevel > 249) and SelectMonster ~= "Dangerous Prisone" then
                                                if MyLevel >= 250 and MyLevel <= 274 or SelectMonster == "Toga Warrior" then
                                                    Mon = "Toga Warrior"
                                                    LevelQuest = 1
                                                    NameQuest = "ColosseumQuest"
                                                    NameMon = "Toga Warrior"
                                                    CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, -0, -0.857167721, -0, 1, -0, 0.857167721, -0, -0.515037298)
                                                    CFrameMon = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)
                                                elseif (MyLevel < 275 or MyLevel > 299) and SelectMonster ~= "Gladiator" then
                                                    if (MyLevel < 300 or MyLevel > 324) and SelectMonster ~= "Military Soldier" then
                                                        if (MyLevel < 325 or MyLevel > 374) and SelectMonster ~= "Military Spy" then
                                                            if (MyLevel < 375 or MyLevel > 399) and SelectMonster ~= "Fishman Warrior" then
                                                                if (MyLevel < 400 or MyLevel > 449) and SelectMonster ~= "Fishman Commando" then
                                                                    if MyLevel >= 450 and MyLevel <= 474 or SelectMonster == "God's Guard" then
                                                                        Mon = "God's Guard"
                                                                        LevelQuest = 1
                                                                        NameQuest = "SkyExp1Quest"
                                                                        NameMon = "God's Guard"
                                                                        CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, -0, 1, -0, 0.0871884301, -0, 0.996191859)
                                                                        CFrameMon = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)
                                                                        if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
                                                                        end
                                                                    elseif MyLevel >= 475 and MyLevel <= 524 or SelectMonster == "Shanda" then
                                                                        Mon = "Shanda"
                                                                        LevelQuest = 2
                                                                        NameQuest = "SkyExp1Quest"
                                                                        NameMon = "Shanda"
                                                                        CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, -0, 0.906319618, -0, 1, -0, -0.906319618, -0, -0.422592998)
                                                                        CFrameMon = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)
                                                                        if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
                                                                        end
                                                                    elseif MyLevel >= 525 and MyLevel <= 549 or SelectMonster == "Royal Squad" then
                                                                        Mon = "Royal Squad"
                                                                        LevelQuest = 1
                                                                        NameQuest = "SkyExp2Quest"
                                                                        NameMon = "Royal Squad"
                                                                        CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                                        CFrameMon = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
                                                                    elseif (MyLevel < 550 or MyLevel > 624) and SelectMonster ~= "Royal Soldier" then
                                                                        if MyLevel >= 625 and MyLevel <= 649 or SelectMonster == "Galley Pirate" then
                                                                            Mon = "Galley Pirate"
                                                                            LevelQuest = 1
                                                                            NameQuest = "FountainQuest"
                                                                            NameMon = "Galley Pirate"
                                                                            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, 0.087131381)
                                                                            CFrameMon = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
                                                                        elseif MyLevel >= 650 or SelectMonster == "Galley Captain" then
                                                                            Mon = "Galley Captain"
                                                                            LevelQuest = 2
                                                                            NameQuest = "FountainQuest"
                                                                            NameMon = "Galley Captain"
                                                                            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, 0.087131381)
                                                                            CFrameMon = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
                                                                        end
                                                                    else
                                                                        Mon = "Royal Soldier"
                                                                        LevelQuest = 2
                                                                        NameQuest = "SkyExp2Quest"
                                                                        NameMon = "Royal Soldier"
                                                                        CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                                        CFrameMon = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
                                                                    end
                                                                else
                                                                    Mon = "Fishman Commando"
                                                                    LevelQuest = 2
                                                                    NameQuest = "FishmanQuest"
                                                                    NameMon = "Fishman Commando"
                                                                    CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                                                                    CFrameMon = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)
                                                                    if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                                                                    end
                                                                end
                                                            else
                                                                Mon = "Fishman Warrior"
                                                                LevelQuest = 1
                                                                NameQuest = "FishmanQuest"
                                                                NameMon = "Fishman Warrior"
                                                                CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                                                                CFrameMon = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)
                                                                if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                                                                end
                                                            end
                                                        else
                                                            Mon = "Military Spy"
                                                            LevelQuest = 2
                                                            NameQuest = "MagmaQuest"
                                                            NameMon = "Military Spy"
                                                            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, -0.499959469)
                                                            CFrameMon = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)
                                                        end
                                                    else
                                                        Mon = "Military Soldier"
                                                        LevelQuest = 1
                                                        NameQuest = "MagmaQuest"
                                                        NameMon = "Military Soldier"
                                                        CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, -0.499959469)
                                                        CFrameMon = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)
                                                    end
                                                else
                                                    Mon = "Gladiator"
                                                    LevelQuest = 2
                                                    NameQuest = "ColosseumQuest"
                                                    NameMon = "Gladiator"
                                                    CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, -0, -0.857167721, -0, 1, -0, 0.857167721, -0, -0.515037298)
                                                    CFrameMon = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)
                                                end
                                            else
                                                Mon = "Dangerous Prisoner"
                                                LevelQuest = 2
                                                NameQuest = "PrisonerQuest"
                                                NameMon = "Dangerous Prisoner"
                                                CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918E-9, -0.995993316, 1.60817859E-9, 1, -5.16744869E-9, 0.995993316, -2.06384709E-9, -0.0894274712)
                                                CFrameMon = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
                                            end
                                        else
                                            Mon = "Dark Master"
                                            LevelQuest = 2
                                            NameQuest = "SkyQuest"
                                            NameMon = "Dark Master"
                                            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
                                            CFrameMon = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)
                                        end
                                    else
                                        Mon = "Sky Bandit"
                                        LevelQuest = 1
                                        NameQuest = "SkyQuest"
                                        NameMon = "Sky Bandit"
                                        CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
                                        CFrameMon = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)
                                    end
                                else
                                    Mon = "Chief Petty Officer"
                                    LevelQuest = 1
                                    NameQuest = "MarineQuest2"
                                    NameMon = "Chief Petty Officer"
                                    CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                    CFrameMon = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
                                end
                            else
                                Mon = "Snow Bandit"
                                LevelQuest = 1
                                NameQuest = "SnowQuest"
                                NameMon = "Snow Bandit"
                                CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, -0, 0.939684391, -0, 1, -0, -0.939684391, -0, -0.342042685)
                                CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
                            end
                        else
                            Mon = "Desert Officer"
                            LevelQuest = 2
                            NameQuest = "DesertQuest"
                            NameMon = "Desert Officer"
                            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693)
                            CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
                        end
                    else
                        Mon = "Brute"
                        LevelQuest = 2
                        NameQuest = "BuggyQuest1"
                        NameMon = "Brute"
                        CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, -0, 1, -0, 0.258804798, -0, 0.965929627)
                        CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
                    end
                else
                    Mon = "Pirate"
                    LevelQuest = 1
                    NameQuest = "BuggyQuest1"
                    NameMon = "Pirate"
                    CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, -0, 1, -0, 0.258804798, -0, 0.965929627)
                    CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
                end
            else
                Mon = "Gorilla"
                LevelQuest = 2
                NameQuest = "JungleQuest"
                NameMon = "Gorilla"
                CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, -0, -0, 1, -0, 1, -0, -1, -0, -0)
                CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
            end
        else
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, -0, -0, 1, -0, 1, -0, -1, -0, -0)
            CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
        end
    elseif not World2 then
        if World3 then
            if MyLevel >= 1500 and MyLevel <= 1524 or SelectMonster == "Pirate Millionaire" then
                Mon = "Pirate Millionaire"
                LevelQuest = 1
                NameQuest = "PiratePortQuest"
                NameMon = "Pirate Millionaire"
                CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.957107544, -0, -0.289732844, -0, 1, -0, 0.289732844, -0, 0.957107544)
                CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
            elseif (MyLevel < 1525 or MyLevel > 1574) and SelectMonster ~= "Pistol Billionaire" then
                if MyLevel >= 1575 and MyLevel <= 1599 or SelectMonster == "Dragon Crew Warrior" then
                    Mon = "Dragon Crew Warrior"
                    LevelQuest = 1
                    NameQuest = "DragonCrewQuest"
                    NameMon = "Dragon Crew Warrior"
                    CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625)
                    CFrameMon = CFrame.new(6709.76367, 52.3442993, -1139.02966, -0.763515472, -0, 0.645789504, -0, 1, -0, -0.645789504, -0, -0.763515472)
                elseif MyLevel >= 1600 and MyLevel <= 1624 or SelectMonster == "Dragon Crew Archer" then
                    Mon = "Dragon Crew Archer"
                    NameQuest = "DragonCrewQuest"
                    LevelQuest = 2
                    NameMon = "Dragon Crew Archer"
                    CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625)
                    CFrameMon = CFrame.new(6668.76172, 481.376923, 329.12207, -0.121787429, -0, -0.992556155, -0, 1, -0, 0.992556155, -0, -0.121787429)
                elseif (MyLevel < 1625 or MyLevel > 1649) and SelectMonster ~= "Hydra Enforcer" then
                    if (MyLevel < 1650 or MyLevel > 1699) and SelectMonster ~= "Venomous Assailant" then
                        if (MyLevel < 1700 or MyLevel > 1724) and SelectMonster ~= "Marine Commodore" then
                            if (MyLevel < 1725 or MyLevel > 1774) and SelectMonster ~= "Marine Rear Admiral" then
                                if (MyLevel < 1775 or MyLevel > 1799) and SelectMonster ~= "Fishman Raider" then
                                    if MyLevel >= 1800 and MyLevel <= 1824 or SelectMonster == "Fishman Captain" then
                                        Mon = "Fishman Captain"
                                        LevelQuest = 2
                                        NameQuest = "DeepForestIsland3"
                                        NameMon = "Fishman Captain"
                                        CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
                                        CFrameMon = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)
                                    elseif (MyLevel < 1825 or MyLevel > 1849) and SelectMonster ~= "Forest Pirate" then
                                        if (MyLevel < 1850 or MyLevel > 1899) and SelectMonster ~= "Mythological Pirate" then
                                            if MyLevel >= 1900 and MyLevel <= 1924 or SelectMonster == "Jungle Pirate" then
                                                Mon = "Jungle Pirate"
                                                LevelQuest = 1
                                                NameQuest = "DeepForestIsland2"
                                                NameMon = "Jungle Pirate"
                                                CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, -0.0871315002)
                                                CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
                                            elseif MyLevel >= 1925 and MyLevel <= 1974 or SelectMonster == "Musketeer Pirate" then
                                                Mon = "Musketeer Pirate"
                                                LevelQuest = 2
                                                NameQuest = "DeepForestIsland2"
                                                NameMon = "Musketeer Pirate"
                                                CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, -0.0871315002)
                                                CFrameMon = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
                                            elseif MyLevel >= 1975 and MyLevel <= 1999 or SelectMonster == "Reborn Skeleton" then
                                                Mon = "Reborn Skeleton"
                                                LevelQuest = 1
                                                NameQuest = "HauntedQuest1"
                                                NameMon = "Reborn Skeleton"
                                                CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, -0, -0, 1, -0, 1, -0, -1, -0, -0)
                                                CFrameMon = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
                                            elseif (MyLevel < 2000 or MyLevel > 2024) and SelectMonster ~= "Living Zombie" then
                                                if MyLevel >= 2025 and MyLevel <= 2049 or SelectMonster == "Demonic Soul" then
                                                    Mon = "Demonic Soul"
                                                    LevelQuest = 1
                                                    NameQuest = "HauntedQuest2"
                                                    NameMon = "Demonic Soul"
                                                    CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                    CFrameMon = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
                                                elseif MyLevel >= 2050 and MyLevel <= 2074 or SelectMonster == "Posessed Mummy" then
                                                    Mon = "Posessed Mummy"
                                                    LevelQuest = 2
                                                    NameQuest = "HauntedQuest2"
                                                    NameMon = "Posessed Mummy"
                                                    CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                    CFrameMon = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
                                                elseif (MyLevel < 2075 or MyLevel > 2099) and SelectMonster ~= "Peanut Scout" then
                                                    if MyLevel >= 2100 and MyLevel <= 2124 or SelectMonster == "Peanut President" then
                                                        Mon = "Peanut President"
                                                        LevelQuest = 2
                                                        NameQuest = "NutsIslandQuest"
                                                        NameMon = "Peanut President"
                                                        CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                        CFrameMon = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
                                                    elseif MyLevel >= 2125 and MyLevel <= 2149 or SelectMonster == "Ice Cream Chef" then
                                                        Mon = "Ice Cream Chef"
                                                        LevelQuest = 1
                                                        NameQuest = "IceCreamIslandQuest"
                                                        NameMon = "Ice Cream Chef"
                                                        CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                        CFrameMon = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
                                                    elseif MyLevel >= 2150 and MyLevel <= 2199 or SelectMonster == "Ice Cream Commander" then
                                                        Mon = "Ice Cream Commander"
                                                        LevelQuest = 2
                                                        NameQuest = "IceCreamIslandQuest"
                                                        NameMon = "Ice Cream Commander"
                                                        CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                        CFrameMon = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
                                                    elseif MyLevel >= 2200 and MyLevel <= 2224 or SelectMonster == "Cookie Crafter" then
                                                        Mon = "Cookie Crafter"
                                                        LevelQuest = 1
                                                        NameQuest = "CakeQuest1"
                                                        NameMon = "Cookie Crafter"
                                                        CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053E-8, 0.288177818, 6.9301187E-8, 1, 7.51931211E-8, -0.288177818, -5.2032135E-8, 0.957576931)
                                                        CFrameMon = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
                                                    elseif (MyLevel < 2225 or MyLevel > 2249) and SelectMonster ~= "Cake Guard" then
                                                        if MyLevel >= 2250 and MyLevel <= 2274 or SelectMonster == "Baking Staff" then
                                                            Mon = "Baking Staff"
                                                            LevelQuest = 1
                                                            NameQuest = "CakeQuest2"
                                                            NameMon = "Baking Staff"
                                                            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143E-8, 0.250778586, 4.74911062E-8, 1, 1.49904711E-8, -0.250778586, 2.64211941E-8, -0.96804446)
                                                            CFrameMon = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
                                                        elseif MyLevel >= 2275 and MyLevel <= 2299 or SelectMonster == "Head Baker" then
                                                            Mon = "Head Baker"
                                                            LevelQuest = 2
                                                            NameQuest = "CakeQuest2"
                                                            NameMon = "Head Baker"
                                                            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143E-8, 0.250778586, 4.74911062E-8, 1, 1.49904711E-8, -0.250778586, 2.64211941E-8, -0.96804446)
                                                            CFrameMon = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
                                                        elseif (MyLevel < 2300 or MyLevel > 2324) and SelectMonster ~= "Cocoa Warrior" then
                                                            if MyLevel >= 2325 and MyLevel <= 2349 or SelectMonster == "Chocolate Bar Battler" then
                                                                Mon = "Chocolate Bar Battler"
                                                                LevelQuest = 2
                                                                NameQuest = "ChocQuest1"
                                                                NameMon = "Chocolate Bar Battler"
                                                                CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
                                                                CFrameMon = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
                                                            elseif MyLevel >= 2350 and MyLevel <= 2374 or SelectMonster == "Sweet Thief" then
                                                                Mon = "Sweet Thief"
                                                                LevelQuest = 1
                                                                NameQuest = "ChocQuest2"
                                                                NameMon = "Sweet Thief"
                                                                CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
                                                                CFrameMon = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
                                                            elseif MyLevel >= 2375 and MyLevel <= 2399 or SelectMonster == "Candy Rebel" then
                                                                Mon = "Candy Rebel"
                                                                LevelQuest = 2
                                                                NameQuest = "ChocQuest2"
                                                                NameMon = "Candy Rebel"
                                                                CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
                                                                CFrameMon = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
                                                            elseif (MyLevel < 2400 or MyLevel > 2424) and SelectMonster ~= "Candy Pirate" then
                                                                if MyLevel >= 2425 and MyLevel <= 2449 or SelectMonster == "Snow Demon" then
                                                                    Mon = "Snow Demon"
                                                                    LevelQuest = 2
                                                                    NameQuest = "CandyQuest1"
                                                                    NameMon = "Snow Demon"
                                                                    CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
                                                                    CFrameMon = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)
                                                                elseif MyLevel >= 2450 and MyLevel <= 2474 or SelectMonster == "Isle Outlaw" then
                                                                    Mon = "Isle Outlaw"
                                                                    LevelQuest = 1
                                                                    NameQuest = "TikiQuest1"
                                                                    NameMon = "Isle Outlaw"
                                                                    CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
                                                                    CFrameMon = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656)
                                                                elseif (MyLevel < 2475 or MyLevel > 2524) and SelectMonster ~= "Island Boy" then
                                                                    if MyLevel >= 2525 and MyLevel <= 2550 or SelectMonster == "Isle Champion" then
                                                                        Mon = "Isle Champion"
                                                                        LevelQuest = 2
                                                                        NameQuest = "TikiQuest2"
                                                                        NameMon = "Isle Champion"
                                                                        CFrameQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
                                                                        CFrameMon = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375)
                                                                    elseif (MyLevel < 2550 or MyLevel > 2574) and SelectMonster ~= "Serpent Hunter" then
                                                                        if MyLevel >= 2575 or SelectMonster == "Skull Slayer" then
                                                                            Mon = "Skull Slayer"
                                                                            LevelQuest = 2
                                                                            NameQuest = "TikiQuest3"
                                                                            NameMon = "Skull Slayer"
                                                                            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, -0, 1, -0, 0.308980465, -0, 0.951068401)
                                                                            CFrameMon = CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, -0, -0.0348687991, -0, 1, -0, 0.0348687991, -0, -0.999392271)
                                                                        end
                                                                    else
                                                                        Mon = "Serpent Hunter"
                                                                        LevelQuest = 1
                                                                        NameQuest = "TikiQuest3"
                                                                        NameMon = "Serpent Hunter"
                                                                        CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, -0, 1, -0, 0.308980465, -0, 0.951068401)
                                                                        CFrameMon = CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, -0, 0.882950008, -0, 1, -0, -0.882950008, -0, 0.469467044)
                                                                    end
                                                                else
                                                                    Mon = "Island Boy"
                                                                    LevelQuest = 2
                                                                    NameQuest = "TikiQuest1"
                                                                    NameMon = "Island Boy"
                                                                    CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
                                                                    CFrameMon = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562)
                                                                end
                                                            else
                                                                Mon = "Candy Pirate"
                                                                LevelQuest = 1
                                                                NameQuest = "CandyQuest1"
                                                                NameMon = "Candy Pirate"
                                                                CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
                                                                CFrameMon = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
                                                            end
                                                        else
                                                            Mon = "Cocoa Warrior"
                                                            LevelQuest = 1
                                                            NameQuest = "ChocQuest1"
                                                            NameMon = "Cocoa Warrior"
                                                            CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
                                                            CFrameMon = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
                                                        end
                                                    else
                                                        Mon = "Cake Guard"
                                                        LevelQuest = 2
                                                        NameQuest = "CakeQuest1"
                                                        NameMon = "Cake Guard"
                                                        CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053E-8, 0.288177818, 6.9301187E-8, 1, 7.51931211E-8, -0.288177818, -5.2032135E-8, 0.957576931)
                                                        CFrameMon = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
                                                    end
                                                else
                                                    Mon = "Peanut Scout"
                                                    LevelQuest = 1
                                                    NameQuest = "NutsIslandQuest"
                                                    NameMon = "Peanut Scout"
                                                    CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, -0, -0, -1, -0, 1, -0, 1, -0, -0)
                                                    CFrameMon = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
                                                end
                                            else
                                                Mon = "Living Zombie"
                                                LevelQuest = 2
                                                NameQuest = "HauntedQuest1"
                                                NameMon = "Living Zombie"
                                                CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, -0, -0, 1, -0, 1, -0, -1, -0, -0)
                                                CFrameMon = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
                                            end
                                        else
                                            Mon = "Mythological Pirate"
                                            LevelQuest = 2
                                            NameQuest = "DeepForestIsland"
                                            NameMon = "Mythological Pirate"
                                            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, -0, 1, -0, 0.707079291, -0, 0.707134247)
                                            CFrameMon = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
                                        end
                                    else
                                        Mon = "Forest Pirate"
                                        LevelQuest = 1
                                        NameQuest = "DeepForestIsland"
                                        NameMon = "Forest Pirate"
                                        CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, -0, 1, -0, 0.707079291, -0, 0.707134247)
                                        CFrameMon = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
                                    end
                                else
                                    Mon = "Fishman Raider"
                                    LevelQuest = 1
                                    NameQuest = "DeepForestIsland3"
                                    NameMon = "Fishman Raider"
                                    CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
                                    CFrameMon = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
                                end
                            else
                                Mon = "Marine Rear Admiral"
                                LevelQuest = 2
                                NameQuest = "MarineTreeIsland"
                                NameMon = "Marine Rear Admiral"
                                CFrameQuest = CFrame.new(2481.09228515625, 74.27049255371094, -6779.640625)
                                CFrameMon = CFrame.new(3761.81006, 123.912003, -6823.52197, 0.961273968, -0, 0.275594592, -0, 1, -0, -0.275594592, -0, 0.961273968)
                            end
                        else
                            Mon = "Marine Commodore"
                            LevelQuest = 1
                            NameQuest = "MarineTreeIsland"
                            NameMon = "Marine Commodore"
                            CFrameQuest = CFrame.new(2481.09228515625, 74.27049255371094, -6779.640625)
                            CFrameMon = CFrame.new(2577.25391, 75.6100006, -7739.87207, 0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, 0.499959469)
                        end
                    else
                        Mon = "Venomous Assailant"
                        NameQuest = "VenomCrewQuest"
                        LevelQuest = 2
                        NameMon = "Venomous Assailant"
                        CFrameQuest = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
                        CFrameMon = CFrame.new(4674.92676, 1134.82654, 996.308838, 0.731321394, -0, -0.682033002, -0, 1, -0, 0.682033002, -0, 0.731321394)
                    end
                else
                    Mon = "Hydra Enforcer"
                    NameQuest = "VenomCrewQuest"
                    LevelQuest = 1
                    NameMon = "Hydra Enforcer"
                    CFrameQuest = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
                    CFrameMon = CFrame.new(4547.11523, 1003.10217, 334.194824, 0.388810456, -0, -0.921317935, -0, 1, -0, 0.921317935, -0, 0.388810456)
                end
            else
                Mon = "Pistol Billionaire"
                LevelQuest = 2
                NameQuest = "PiratePortQuest"
                NameMon = "Pistol Billionaire"
                CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.957107544, -0, -0.289732844, -0, 1, -0, 0.289732844, -0, 0.957107544)
                CFrameMon = CFrame.new(-54.8110352, 83.7698746, 5947.84082, -0.965929747, -0, 0.258804798, -0, 1, -0, -0.258804798, -0, -0.965929747)
            end
        end
    elseif (MyLevel < 700 or MyLevel > 724) and SelectMonster ~= "Raider" then
        if MyLevel >= 725 and MyLevel <= 774 or SelectMonster == "Mercenary" then
            Mon = "Mercenary"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, -0, -0.974368095, -0, 1, -0, 0.974368095, -0, -0.22495985)
            CFrameMon = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
        elseif MyLevel >= 775 and MyLevel <= 799 or SelectMonster == "Swan Pirate" then
            Mon = "Swan Pirate"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, -0, 0.99026376, -0, 1, -0, -0.99026376, -0, 0.139203906)
            CFrameMon = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
        elseif (MyLevel < 800 or MyLevel > 874) and SelectMonster ~= "Factory Staff" then
            if MyLevel >= 875 and MyLevel <= 899 or SelectMonster == "Marine Lieutenant" then
                Mon = "Marine Lieutenant"
                LevelQuest = 1
                NameQuest = "MarineQuest3"
                NameMon = "Marine Lieutenant"
                CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
                CFrameMon = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
            elseif MyLevel >= 900 and MyLevel <= 949 or SelectMonster == "Marine Captain" then
                Mon = "Marine Captain"
                LevelQuest = 2
                NameQuest = "MarineQuest3"
                NameMon = "Marine Captain"
                CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
                CFrameMon = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
            elseif (MyLevel < 950 or MyLevel > 974) and SelectMonster ~= "Zombie" then
                if MyLevel >= 975 and MyLevel <= 999 or SelectMonster == "Vampire" then
                    Mon = "Vampire"
                    LevelQuest = 2
                    NameQuest = "ZombieQuest"
                    NameMon = "Vampire"
                    CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, -0, -0.95628953, -0, 1, -0, 0.95628953, -0, -0.29242146)
                    CFrameMon = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
                elseif (MyLevel < 1000 or MyLevel > 1049) and SelectMonster ~= "Snow Trooper" then
                    if MyLevel >= 1050 and MyLevel <= 1099 or SelectMonster == "Winter Warrior" then
                        Mon = "Winter Warrior"
                        LevelQuest = 2
                        NameQuest = "SnowMountainQuest"
                        NameMon = "Winter Warrior"
                        CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, -0, 0.92718488, -0, 1, -0, -0.92718488, -0, -0.374604106)
                        CFrameMon = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
                    elseif MyLevel >= 1100 and MyLevel <= 1124 or SelectMonster == "Lab Subordinate" then
                        Mon = "Lab Subordinate"
                        LevelQuest = 1
                        NameQuest = "IceSideQuest"
                        NameMon = "Lab Subordinate"
                        CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, -0, 1, -0, 0.891015649, -0, 0.453972578)
                        CFrameMon = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
                    elseif MyLevel >= 1125 and MyLevel <= 1174 or SelectMonster == "Horned Warrior" then
                        Mon = "Horned Warrior"
                        LevelQuest = 2
                        NameQuest = "IceSideQuest"
                        NameMon = "Horned Warrior"
                        CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, -0, 1, -0, 0.891015649, -0, 0.453972578)
                        CFrameMon = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
                    elseif (MyLevel < 1175 or MyLevel > 1199) and SelectMonster ~= "Magma Ninja" then
                        if (MyLevel < 1200 or MyLevel > 1249) and SelectMonster ~= "Lava Pirate" then
                            if MyLevel >= 1250 and MyLevel <= 1274 or SelectMonster == "Ship Deckhand" then
                                Mon = "Ship Deckhand"
                                LevelQuest = 1
                                NameQuest = "ShipQuest1"
                                NameMon = "Ship Deckhand"
                                CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
                                CFrameMon = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)
                                if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                end
                            elseif (MyLevel < 1275 or MyLevel > 1299) and SelectMonster ~= "Ship Engineer" then
                                if MyLevel >= 1300 and MyLevel <= 1324 or SelectMonster == "Ship Steward" then
                                    Mon = "Ship Steward"
                                    LevelQuest = 1
                                    NameQuest = "ShipQuest2"
                                    NameMon = "Ship Steward"
                                    CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
                                    CFrameMon = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)
                                    if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                    end
                                elseif (MyLevel < 1325 or MyLevel > 1349) and SelectMonster ~= "Ship Officer" then
                                    if (MyLevel < 1350 or MyLevel > 1374) and SelectMonster ~= "Arctic Warrior" then
                                        if MyLevel >= 1375 and MyLevel <= 1424 or SelectMonster == "Snow Lurker" then
                                            Mon = "Snow Lurker"
                                            LevelQuest = 2
                                            NameQuest = "FrostQuest"
                                            NameMon = "Snow Lurker"
                                            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, -0, -0.358349502, -0, 1, -0, 0.358349502, -0, -0.933587909)
                                            CFrameMon = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
                                        elseif (MyLevel < 1425 or MyLevel > 1449) and SelectMonster ~= "Sea Soldier" then
                                            if MyLevel >= 1450 or SelectMonster == "Water Fighter" then
                                                Mon = "Water Fighter"
                                                LevelQuest = 2
                                                NameQuest = "ForgottenQuest"
                                                NameMon = "Water Fighter"
                                                CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, -0, 1, -0, 0.13915664, -0, 0.990270376)
                                                CFrameMon = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)
                                            end
                                        else
                                            Mon = "Sea Soldier"
                                            LevelQuest = 1
                                            NameQuest = "ForgottenQuest"
                                            NameMon = "Sea Soldier"
                                            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, -0, 1, -0, 0.13915664, -0, 0.990270376)
                                            CFrameMon = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
                                        end
                                    else
                                        Mon = "Arctic Warrior"
                                        LevelQuest = 1
                                        NameQuest = "FrostQuest"
                                        NameMon = "Arctic Warrior"
                                        CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, -0, -0.358349502, -0, 1, -0, 0.358349502, -0, -0.933587909)
                                        CFrameMon = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)
                                        if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-6508.5581054688, 5000.034996032715, -132.83953857422))
                                        end
                                    end
                                else
                                    Mon = "Ship Officer"
                                    LevelQuest = 2
                                    NameQuest = "ShipQuest2"
                                    NameMon = "Ship Officer"
                                    CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
                                    CFrameMon = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
                                    if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                    end
                                end
                            else
                                Mon = "Ship Engineer"
                                LevelQuest = 2
                                NameQuest = "ShipQuest1"
                                NameMon = "Ship Engineer"
                                CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
                                CFrameMon = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)
                                if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                end
                            end
                        else
                            Mon = "Lava Pirate"
                            LevelQuest = 2
                            NameQuest = "FireSideQuest"
                            NameMon = "Lava Pirate"
                            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
                            CFrameMon = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
                        end
                    else
                        Mon = "Magma Ninja"
                        LevelQuest = 1
                        NameQuest = "FireSideQuest"
                        NameMon = "Magma Ninja"
                        CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
                        CFrameMon = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
                    end
                else
                    Mon = "Snow Trooper"
                    LevelQuest = 1
                    NameQuest = "SnowMountainQuest"
                    NameMon = "Snow Trooper"
                    CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, -0, 0.92718488, -0, 1, -0, -0.92718488, -0, -0.374604106)
                    CFrameMon = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
                end
            else
                Mon = "Zombie"
                LevelQuest = 1
                NameQuest = "ZombieQuest"
                NameMon = "Zombie"
                CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, -0, -0.95628953, -0, 1, -0, 0.95628953, -0, -0.29242146)
                CFrameMon = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
            end
        else
            Mon = "Factory Staff"
            NameQuest = "Area2Quest"
            LevelQuest = 2
            NameMon = "Factory Staff"
            CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881E-10, -0.999488771, 1.36326533E-10, 1, 8.92172336E-10, 0.999488771, -1.07732087E-10, -0.0319722369)
            CFrameMon = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
        end
    else
        Mon = "Raider"
        LevelQuest = 1
        NameQuest = "Area1Quest"
        NameMon = "Raider"
        CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, -0, -0.974368095, -0, 1, -0, 0.974368095, -0, -0.22495985)
        CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
    end
end

function AutoHaki()
    local l_Character_0 = game:GetService("Players").LocalPlayer.Character
    if l_Character_0 and not l_Character_0:FindFirstChild("HasBuso") then
        local l_CommF__0 = game:GetService("ReplicatedStorage").Remotes.CommF_
        if l_CommF__0 then
            l_CommF__0:InvokeServer("Buso")
        end
    end
end

function EquipWeapon(v358)
    if not _G.NotAutoEquip and game.Players.LocalPlayer.Backpack:FindFirstChild(v358) then
        Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(v358)
        wait(0.1)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end
end
spawn(function()
    local v359 = getrawmetatable(game)
    local l___namecall_0 = v359.__namecall
    setreadonly(v359, false)
    v359.__namecall = newcclosure(function(...)
        local v361 = getnamecallmethod()
        local v362 = {...}
        if tostring(v361) == "FireServer" and tostring(v362[1]) == "RemoteEvent" and tostring(v362[2]) ~= "true" and tostring(v362[2]) ~= "false" and _G.UseSkill then
            if type(v362[2]) ~= "vector" then
                v362[2] = CFrame.new(PositionSkillMasteryDevilFruit)
            else
                v362[2] = PositionSkillMasteryDevilFruit
            end
            return l___namecall_0(unpack(v362))
        else
            return l___namecall_0(...)
        end
    end)
end)
spawn(function()
    pcall(function()
        while task.wait() do
            for _, v364 in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if v364:IsA("Tool") and v364:FindFirstChild("RemoteFunctionShoot") then
                    CurrentEquipGun = v364.Name
                end
            end
        end
    end)
end)

function WaitHRP(v392)
    if v392 then
        return v392.Character:WaitForChild("HumanoidRootPart", 9)
    else
        return 
    end
end

function CheckNearestTeleporter(v393)
    local l_Position_1 = v393.Position
    local l_huge_0 = math.huge
    local v396 = nil
    local l_PlaceId_1 = game.PlaceId
    local v398 = {}
    if l_PlaceId_1 ~= 2753915549 then
        if l_PlaceId_1 ~= 4442272183 then
            if l_PlaceId_1 == 7449423635 then
                v398 = {
                    ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
                    ["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
                    Mansion = Vector3.new(-12462, 375, -7552),
                    Castle = Vector3.new(-5036, 315, -3179),
                    ["Dimensional Shift"] = Vector3.new(-2097.3447265625, 4776.24462890625, -15013.4990234375),
                    ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
                    ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276, 1, 2.14762768E-8, -1.99111154E-13, -2.14762768E-8, 1, -3.0510602E-8, 1.98455903E-13, 3.0510602E-8, 1),
                    ["Temple of Time"] = Vector3.new(28286, 14897, 103)
                }
            end
        else
            v398 = {
                ["Swan Mansion"] = Vector3.new(-390, 332, 673),
                ["Swan Room"] = Vector3.new(2285, 15, 905),
                ["Cursed Ship"] = Vector3.new(923, 126, 32852),
                ["Zombie Island"] = Vector3.new(-6509, 83, -133)
            }
        end
    else
        v398 = {
            Sky3 = Vector3.new(-7894, 5547, -380),
            Sky3Exit = Vector3.new(-4607, 874, -1667),
            UnderWater = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
            UnderwaterExit = Vector3.new(4050, -1, -1814)
        }
    end
    for _, v400 in pairs(v398) do
        local l_Magnitude_1 = (v400 - l_Position_1).Magnitude
        if l_Magnitude_1 < l_huge_0 then
            l_huge_0 = l_Magnitude_1
            v396 = v400
        end
    end
    if l_huge_0 <= (l_Position_1 - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude then
        return v396
    else
        return 
    end
end

function requestEntrance(v402)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", v402)
    local l_HumanoidRootPart_3 = game.Players.LocalPlayer.Character.HumanoidRootPart
    l_HumanoidRootPart_3.CFrame = l_HumanoidRootPart_3.CFrame + Vector3.new(0, 50, 0)
    task.wait(0.5)
end

function topos(v405)
    local l_LocalPlayer_1 = game.Players.LocalPlayer
    if l_LocalPlayer_1.Character and l_LocalPlayer_1.Character.Humanoid.Health > 0 and l_LocalPlayer_1.Character:FindFirstChild("HumanoidRootPart") then
        local l_Magnitude_2 = (v405.Position - l_LocalPlayer_1.Character.HumanoidRootPart.Position).Magnitude
        if not v405 then
            return 
        else
            local v408 = CheckNearestTeleporter(v405)
            if v408 then
                requestEntrance(v408)
            end
            if not l_LocalPlayer_1.Character:FindFirstChild("PartTele") then
                local v409 = Instance.new("Part", l_LocalPlayer_1.Character)
                v409.Size = Vector3.new(10, 1, 10)
                v409.Name = "PartTele"
                v409.Anchored = true
                v409.Transparency = 1
                v409.CanCollide = true
                v409.CFrame = WaitHRP(l_LocalPlayer_1).CFrame
                do
                    local l_v409_0 = v409
                    l_v409_0:GetPropertyChangedSignal("CFrame"):Connect(function()
                        if not v391 then
                            return 
                        else
                            task.wait()
                            if l_LocalPlayer_1.Character and l_LocalPlayer_1.Character:FindFirstChild("HumanoidRootPart") then
                                WaitHRP(l_LocalPlayer_1).CFrame = l_v409_0.CFrame
                            end
                            return 
                        end
                    end)
                end
            end
            v391 = true
            local v411 = game:GetService("TweenService"):Create(l_LocalPlayer_1.Character.PartTele, TweenInfo.new(l_Magnitude_2 / 360, Enum.EasingStyle.Linear), {CFrame = v405})
            v411:Play()
            v411.Completed:Connect(function(v412)
                if v412 == Enum.PlaybackState.Completed then
                    if l_LocalPlayer_1.Character:FindFirstChild("PartTele") then
                        l_LocalPlayer_1.Character.PartTele:Destroy()
                    end
                    v391 = false
                end
            end)
        end
    end
end

function TP1(v418)
    topos(v418)
end
spawn(function()
    while wait() do
        if _G.SpinPos then
            Pos = CFrame.new(0, PosY, -20)
            wait(0.1)
            Pos = CFrame.new(-20, PosY, 0)
            wait(0.1)
            Pos = CFrame.new(0, PosY, 20)
            wait(0.1)
            Pos = CFrame.new(20, PosY, 0)
        else
            Pos = CFrame.new(0, PosY, 0)
        end
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.FarmBone or _G.AutoFarm or _G.Pray or _G.Trylux or _G.Hallow or _G.FarmCake or _G.FarmDaiBan or _G.Greybeard or _G.CursedCaptain or _G.AutoDarkBoss or _G.ChiefWarden or _G.Trident or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodCanvande or _G.SwodsBuddy or _G.FarmBlazeEM or _G.AutoFindPrehistoric or _G.TweenVolcano or _G.DefendVolcano or _G.KillGolem or _G.SwodTwinHooks or _G.Fullykatakuri or _G.AutoBoss or _G.SwodCanvander or _G.AutoFarmMaterial or _G.AutoSecondSea or _G.Autosaw or _G.ChiefWarden or _G.Trident or _G.AutoSaber or _G.ThirdSea or _G.AutoBartilo or _G.AutoFactory or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodTwinHooks or _G.SwodCanvander or _G.AutoRaidPirate or _G.AutoQuestYama or _G.AutoYamaQuest or _G.AutoSaber or _G.DefendVolcano or _G.TPB or _G.SailBoat or _G.Autoterrorshark or _G.KillShark or _G.KillPiranha or _G.KillFishCrew or _G.AutoQuestRace or _G.Dungeon or _G.AutoLawRaid or _G.Tweenfruit or ProjectTrialPro or _G.TweenMGear or _G.AutoMysticIsland or AutoUpgradeRace or AutoRaceEvo1 or _G.AutoFarmFruits or _G.Autopole or _G.Autosaw or _G.AutoElitehunter or FarmMtrFruit or _G.AutoNear or _G.CollectBerry or _G.RipIndraKill or _G.FarmChocola or SoulGuitar or _G.AutoHolyTorch or _G.AutoGetTushita or _G.AutoYama or _G.AutoMobDragon or _G.AutoHydraTree or _G.TweenToKitsune or _G.AutoDooHee or _G.AutoAzuerEmber or _G.TweenVolcano or _G.Dungeon or _G.AutoLawRaid or _G.TweenFruit or _G.Grabfruit or _G.TeleportIsland or _G.TeleportNPC or _G.SafeMode or _G.AutoPlayerHunter or _G.AutoKillPlayer or _G.TeleportPly or _G.AutoQuestBoss or _G.AutoAllBoss or _G.AutoFarmLevelNew or _G.FarmSummer or _G.BossPain then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local l_BodyVelocity_2 = Instance.new("BodyVelocity")
                    l_BodyVelocity_2.Name = "BodyClip"
                    l_BodyVelocity_2.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    l_BodyVelocity_2.MaxForce = Vector3.new(100000, 100000, 100000)
                    l_BodyVelocity_2.Velocity = Vector3.new(0, 0, 0)
                end
            else
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.FarmBone or _G.AutoFarm or _G.Pray or _G.Trylux or _G.Hallow or _G.FarmCake or _G.FarmDaiBan or _G.Fullykatakuri or _G.AutoBoss or _G.AutoMateria or _G.AutoSecondSea or _G.Autosaw or _G.ChiefWarden or _G.Trident or _G.AutoSaber or _G.Greybeard or _G.CursedCaptain or _G.AutoDarkBoss or _G.ChiefWarden or _G.Trident or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodCanvande or _G.SwodTwinHooks or _G.ThirdSea or _G.AutoBartilo or _G.AutoFactory or _G.Longsword or _G.GravityBlade or _G.SwodsFlail or _G.AutoRengoku or _G.SwodsDRTrident or _G.SwodTwinHooks or _G.SwodCanvander or _G.SwodsBuddy or _G.FarmBlazeEM or _G.AutoFindPrehistoric or _G.TweenVolcano or _G.DefendVolcano or _G.KillGolem or _G.AutoRaidPirate or _G.AutoQuestYama or _G.AutoYamaQuest or _G.AutoElitehunter or FarmMtrFruit or AutoUpgradeRace or _G.AutoFarmMaterial or AutoRaceEvo1 or AutoSaber or _G.Autopole or _G.SwodCanvander or _G.DefendVolcano or _G.SailBoat or _G.Autoterrorshark or _G.KillShark or _G.KillPiranha or _G.KillFishCrew or _G.AutoQuestRace or _G.Dungeon or _G.AutoLawRaid or _G.Tweenfruit or ProjectTrialPro or _G.AutoMysticIsland or _G.TweenMGear or _G.Autosaw or _G.AutoNear or _G.AutoFarmFruits or _G.CollectBerry or _G.RipIndraKill or _G.FarmChocola or SoulGuitar or _G.AutoHolyTorch or _G.AutoGetTushita or _G.AutoYama or _G.AutoMobDragon or _G.AutoHydraTree or _G.TweenToKitsune or _G.AutoDooHee or _G.AutoAzuerEmber or _G.TweenVolcano or _G.Dungeon or _G.AutoLawRaid or _G.TweenFruit or _G.Grabfruit or _G.TeleportIsland or _G.TeleportNPC or _G.SafeMode or _G.AutoPlayerHunter or _G.AutoKillPlayer or _G.TeleportPly or _G.AutoQuestBoss or _G.AutoAllBoss or _G.AutoFarmLevelNew or _G.FarmSummer or _G.BossPain then
                for _, v421 in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v421:IsA("BasePart") then
                        v421.CanCollide = false
                    end
                end
            end
        end)
    end)
end)
local v422 = {}

local function HRP()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function IsInSubmerged()
    local hrp = HRP()
    return hrp and hrp.Position.Y < SUBMERGED_Y
end

local function StopTween(state)
    if not state and CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
        CurrentTween = nil
    end
end

local function TweenTo(cf)
    if not _G.AutoFarm then return end
    local hrp = HRP()
    if not hrp then return end

    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
    end

    local dist = (hrp.Position - cf.Position).Magnitude
    local speed = 300
    local t = dist / speed

    CurrentTween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
    CurrentTween:Play()

    while _G.AutoFarm and CurrentTween and CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
        task.wait()
    end

    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
    end
    CurrentTween = nil
end

local function GoSubmerged()
    if not _G.AutoFarm then return end
    if TravelingSubmerged or IsInSubmerged() or LocalPlayer.Data.Level.Value < 2600 then return end

    TravelingSubmerged = true
    TweenTo(SUB_NPC + Vector3.new(0, 60, 0))
    if not _G.AutoFarm then TravelingSubmerged = false return end
    TweenTo(SUB_NPC)
    if not _G.AutoFarm then TravelingSubmerged = false return end

    pcall(function()
        ReplicatedStorage.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
    end)

    while _G.AutoFarm and not IsInSubmerged() do
        task.wait(0.5)
    end

    TravelingSubmerged = false
end

local function CheckQuestNew()
    local lvl = LocalPlayer.Data.Level.Value

    if lvl >= 2600 and lvl <= 2624 then
        MonNew = "Reef Bandit"
        LevelQuestNew = 1
        NameQuestNew = "SubmergedQuest1"
        NameMonNew = "Reef Bandit"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(10736.6191, -2087.8439, 9338.4882)

    elseif lvl >= 2650 and lvl <= 2674 then
        MonNew = "Sea Chanter"
        LevelQuestNew = 1
        NameQuestNew = "SubmergedQuest2"
        NameMonNew = "Sea Chanter"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(10621.0342, -2087.844, 10102.0332)

    elseif lvl >= 2675 and lvl <= 2699 then
        MonNew = "Ocean Prophet"
        LevelQuestNew = 2
        NameQuestNew = "SubmergedQuest2"
        NameMonNew = "Ocean Prophet"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(11056.1445, -2001.6717, 10117.4493)

    elseif lvl >= 2700 and lvl <= 2724 then
        MonNew = "High Disciple"
        LevelQuestNew = 1
        NameQuestNew = "SubmergedQuest3"
        NameMonNew = "High Disciple"
        CFrameQuestNew = CFrame.new(9636.524, -1992.195, 9609.528)
        CFrameMonNew = CFrame.new(9828.088, -1940.909, 9693.064)

    elseif lvl >= 2725 then
        MonNew = "Grand Devotee"
        LevelQuestNew = 2
        NameQuestNew = "SubmergedQuest3"
        NameMonNew = "Grand Devotee"
        CFrameQuestNew = CFrame.new(9636.524, -1992.195, 9609.528)
        CFrameMonNew = CFrame.new(9557.585, -1928.040, 9859.183)

    else
        MonNew = "Coral Pirate"
        LevelQuestNew = 2
        NameQuestNew = "SubmergedQuest1"
        NameMonNew = "Coral Pirate"
        CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
        CFrameMonNew = CFrame.new(10965.1025, -2158.8842, 9177.2597)
    end
end
v485:AddToggle({
    Name = "Auto Farm Level",
    Description = "Farm Level",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        StopTween(_G.AutoFarm)
    end
})
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local currentLevel = LocalPlayer.Data.Level.Value                
                if currentLevel >= 2600 and World3 then
                      if not IsInSubmerged() then
                           GoSubmerged()
                    end
              end                
                if currentLevel >= 2600 and World3 and IsInSubmerged() then
                    CheckQuestNew()
                    
                    local questGui = LocalPlayer.PlayerGui.Main.Quest
                    if not questGui.Visible then
                        StartBring = false
                        if (HRP().Position - CFrameQuestNew.Position).Magnitude > 20 then
                            TweenTo(CFrameQuestNew)
                        else
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuestNew, LevelQuestNew)
                        end
                    else
                        local questText = questGui.Container.QuestTitle.Title.Text
                        if not string.find(questText, NameMonNew) then
                            StartBring = false
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        else
                            for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if mob.Name == MonNew and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        AutoHaki()
                                        topos(mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        mob.HumanoidRootPart.CanCollide = false
                                        mob.Humanoid.WalkSpeed = 0
                                        mob.Head.CanCollide = false
                                        mob.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                        StartBring = true
                                        MonFarm = mob.Name
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    until not _G.AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent or not questGui.Visible
                                end
                            end
                            
                            if not game:GetService("Workspace").Enemies:FindFirstChild(MonNew) then
                                TweenTo(CFrameMonNew)
                                StartBring = false
                            end
                        end
                    end
                else
                    -- Farm Antigo (1-2599)
                    local l_Text_0 = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    CheckQuest()
                    if not string.find(l_Text_0, NameMon) then
                        StartBring = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                            if not string.find(l_Text_0, "kissed") then
                                if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                                    for _, v512 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                        if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name == Mon then
                                            if not string.find(l_Text_0, NameMon) then
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            else
                                                repeat
                                                    task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    AutoHaki()
                                                    PosMon = v512.HumanoidRootPart.CFrame
                                                    topos(v512.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                    v512.HumanoidRootPart.CanCollide = false
                                                    v512.Humanoid.WalkSpeed = 0
                                                    v512.Head.CanCollide = false
                                                    v512.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                                    StartBring = true
                                                    MonFarm = v512.Name
                                                    game:GetService("VirtualUser"):CaptureController()
                                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v512.Humanoid.Health <= 0 or not v512.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            end
                                        end
                                    end
                                else
                                    TP1(CFrameMon)
                                    StartBring = false
                                    if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                    end
                                end
                            else
                                for _, v514 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if string.find(v514.Name, "kissed Warrior") then
                                        if v514:FindFirstChild("HumanoidRootPart") and v514:FindFirstChild("Humanoid") and v514.Humanoid.Health > 0 then
                                            if string.find(l_Text_0, NameMon) then
                                                repeat
                                                    task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    PosMon = v514.HumanoidRootPart.CFrame
                                                    topos(v514.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                    v514.HumanoidRootPart.CanCollide = false
                                                    v514.Humanoid.WalkSpeed = 0
                                                    v514.Head.CanCollide = false
                                                    v514.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                                    StartBring = true
                                                    MonFarm = v514.Name
                                                    game:GetService("VirtualUser"):CaptureController()
                                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v514.Humanoid.Health <= 0 or not v514.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            else
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    else
                                        TP1(CFrameMon)
                                        StartBring = false
                                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                        end
                                    end
                                end
                            end
                        end
                    else
                        StartBring = false
                        if BypassTP then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 1500 then
                                TP1(CFrameQuest)
                            else
                                TP1(CFrameQuest)
                            end
                        else
                            TP1(CFrameQuest)
                        end
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 20 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                        end
                    end
                end
            end)
        end
    end
end)
if World3 then
v485:AddToggle({
    Name = "Auto Pirates Sea",
    Description = "Farm Raid Pirate",
    Default = false,
    Callback = function(v543)
        _G.AutoRaidPirate = v543
        StopTween(_G.AutoRaidPirate)
    end
})
spawn(function()
    while wait() do
        if _G.AutoRaidPirate then
            pcall(function()
                local v544 = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015E-9, 0.380223751, 3.5881019E-8, 1, -1.06665446E-7, -0.380223751, 1.12297109E-7, 0.924894512)
                if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
                    for _, v546 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if _G.AutoRaidPirate and v546:FindFirstChild("HumanoidRootPart") and v546:FindFirstChild("Humanoid") and v546.Humanoid.Health > 0 and (v546.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
                            repeat
                                wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                NeedAttacking = true
                                StartMagnet = true
                                v546.HumanoidRootPart.CanCollide = false
                                v546.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                topos(v546.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            until v546.Humanoid.Health <= 0 or not v546.Parent or _G.AutoRaidPirate == false
                            NeedAttacking = false
                            StartMagnet = false
                        end
                    end
                elseif (v544.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 1500 then
                    TP1(v544)
                else
                    TP1(v544)
                end
            end)
        end
    end
end)
end
if World2 then
    v485:AddToggle({
        Name = "Auto Factory",
        Description = "Spawns Every 1:30 [hours, Minutes]",
        Default = false,
        Callback = function(v732)
            _G.AutoFactory = v732
            StopTween(_G.AutoFactory)
        end
    })
    spawn(function()
        while wait() do
            spawn(function()
                if _G.AutoFactory then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Core") then
                        for _, v734 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v734.Name == "Core" and v734.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    topos(CFrame.new(448.46756, 199.356781, -441.389252))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                until v734.Humanoid.Health <= 0 or _G.AutoFactory == false
                            end
                        end
                    else
                        topos(CFrame.new(448.46756, 199.356781, -441.389252))
                    end
                end
            end)
        end
    end)
 end
v485:AddToggle({
    Name = "Auto Farm Nearest",
    Description = "Auto Farm Nearest Mobs",
    Default = false,
    Callback = function(v520)
        _G.AutoNear = v520
        StopTween(_G.AutoNear)
    end
})
spawn(function()
    while wait() do
        if _G.AutoNear then
            pcall(function()
                for _, v522 in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v522:FindFirstChild("Humanoid") and v522:FindFirstChild("HumanoidRootPart") and v522.Humanoid.Health > 0 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v522.HumanoidRootPart.Position).Magnitude <= 5000 then
                        repeat
                            wait(_G.Fast_Delay)
                            StartBring = true
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            topos(v522.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            v522.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v522.HumanoidRootPart.Transparency = 1
                            v522.Humanoid.JumpPower = 0
                            v522.Humanoid.WalkSpeed = 0
                            v522.HumanoidRootPart.CanCollide = false
                            FarmPos = v522.HumanoidRootPart.CFrame
                            MonFarm = v522.Name
                        until not _G.AutoNear or not v522.Parent or v522.Humanoid.Health <= 0 or not game.Workspace.Enemies:FindFirstChild(v522.Name)
                        StartBring = false
                    end
                end
            end)
        end
    end
end)
local _ = v485:AddSection({"Valentine"})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")

_G.AutoValentineGacha = false

v485:AddToggle({
    Name = "Auto Valentine Random",
    Description = "Auto Gacha Valentine Roll",
    Default = false,
    Callback = function(Value)
        _G.AutoValentineGacha = Value
    end
})

local vu32 = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()
local v466 = vu32:MakeWindow({
    Title = "YTB: tuyenmod2194 ✓⃝",
    SubTitle = "Blox Fruits",
    SaveFolder = "Redz | redz lib v5.lua"
})

v466:AddMinimizeButton({
    Button = { Image = "rbxassetid://115616028926793", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = { CornerRadius = UDim.new(0.25, 0) },
})

local v485 = v466:MakeTab({"Farm", "home"})


_G.SelectWeapon = "Melee"

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                        _G.SelectWeapon = tool.Name
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Sword" then
                        _G.SelectWeapon = tool.Name
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Gun" then
                        _G.SelectWeapon = tool.Name
                    end
                end
            elseif _G.SelectWeapon == "Blox Fruit" then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = tool.Name
                    end
                end
            end
        end)
    end
end)

v485:AddDropdown({
    Name = "Select Tool",
    Description = "Choose the tool you want to use",
    Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Flag = "WeaponType",
    Callback = function(value)
        _G.SelectWeapon = value
    end
})

local _ = v485:AddSection({"Farm"})


v485:AddToggle({
    Name = "Auto Farm Level",
    Description = "Farm Level",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        StopTween(_G.AutoFarm)
    end
})
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local currentLevel = LocalPlayer.Data.Level.Value                
                if currentLevel >= 2600 and World3 then
                      if not IsInSubmerged() then
                           GoSubmerged()
                    end
              end                
                if currentLevel >= 2600 and World3 and IsInSubmerged() then
                    CheckQuestNew()
                    
                    local questGui = LocalPlayer.PlayerGui.Main.Quest
                    if not questGui.Visible then
                        StartBring = false
                        if (HRP().Position - CFrameQuestNew.Position).Magnitude > 20 then
                            TweenTo(CFrameQuestNew)
                        else
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuestNew, LevelQuestNew)
                        end
                    else
                        local questText = questGui.Container.QuestTitle.Title.Text
                        if not string.find(questText, NameMonNew) then
                            StartBring = false
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        else
                            for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if mob.Name == MonNew and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        AutoHaki()
                                        topos(mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        mob.HumanoidRootPart.CanCollide = false
                                        mob.Humanoid.WalkSpeed = 0
                                        mob.Head.CanCollide = false
                                        mob.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                        StartBring = true
                                        MonFarm = mob.Name
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    until not _G.AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent or not questGui.Visible
                                end
                            end
                            
                            if not game:GetService("Workspace").Enemies:FindFirstChild(MonNew) then
                                TweenTo(CFrameMonNew)
                                StartBring = false
                            end
                        end
                    end
                else
                    -- Farm Antigo (1-2599)
                    local l_Text_0 = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    CheckQuest()
                    if not string.find(l_Text_0, NameMon) then
                        StartBring = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                            if not string.find(l_Text_0, "kissed") then
                                if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                                    for _, v512 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                        if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name == Mon then
                                            if not string.find(l_Text_0, NameMon) then
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            else
                                                repeat
                                                    task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    AutoHaki()
                                                    PosMon = v512.HumanoidRootPart.CFrame
                                                    topos(v512.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                    v512.HumanoidRootPart.CanCollide = false
                                                    v512.Humanoid.WalkSpeed = 0
                                                    v512.Head.CanCollide = false
                                                    v512.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                                    StartBring = true
                                                    MonFarm = v512.Name
                                                    game:GetService("VirtualUser"):CaptureController()
                                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v512.Humanoid.Health <= 0 or not v512.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            end
                                        end
                                    end
                                else
                                    TP1(CFrameMon)
                                    StartBring = false
                                    if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                    end
                                end
                            else
                                for _, v514 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if string.find(v514.Name, "kissed Warrior") then
                                        if v514:FindFirstChild("HumanoidRootPart") and v514:FindFirstChild("Humanoid") and v514.Humanoid.Health > 0 then
                                            if string.find(l_Text_0, NameMon) then
                                                repeat
                                                    task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    PosMon = v514.HumanoidRootPart.CFrame
                                                    topos(v514.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                    v514.HumanoidRootPart.CanCollide = false
                                                    v514.Humanoid.WalkSpeed = 0
                                                    v514.Head.CanCollide = false
                                                    v514.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                                    StartBring = true
                                                    MonFarm = v514.Name
                                                    game:GetService("VirtualUser"):CaptureController()
                                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v514.Humanoid.Health <= 0 or not v514.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            else
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    else
                                        TP1(CFrameMon)
                                        StartBring = false
                                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                        end
                                    end
                                end
                            end
                        end
                    else
                        StartBring = false
                        if BypassTP then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 1500 then
                                TP1(CFrameQuest)
                            else
                                TP1(CFrameQuest)
                            end
                        else
                            TP1(CFrameQuest)
                        end
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 20 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                        end
                    end
                end
            end)
        end
    end
end)

return v466
