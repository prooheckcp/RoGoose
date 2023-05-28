--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Signal = require(script.Vendor.Signal)
local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local ModelType = require(script.Enums.ModelType)

--functions
local GeneratePlayerKey = require(script.Functions.GeneratePlayerKey)

local ERROR_TAG: string = "[RoGoose] [ERROR]:"
local SESSION_LOCK_DATASTORE: string = "SessionLockStore"

local RoGoose = {}

--Exposed types
export type Schema = Schema.Schema
export type Model = Model.Model
export type Profile = Profile.Profile
export type ModelType = ModelType.ModelType

--Exposed Classes
RoGoose.Schema = Schema
RoGoose.Model = Model

--Exposed Enums
RoGoose.ModelType = ModelType

--Signals
RoGoose.PlayerAdded = Signal.new() :: Signal.Signal<Player>
RoGoose.PlayerRemoving = Signal.new() :: Signal.Signal<Player>

return RoGoose