return {
	Elements = {
		Paragraph = require("./Paragraph"),
		Button = require("./Button"),
		Toggle = require("./Toggle"),
		Slider = require("./Slider"),
		Keybind = require("./Keybind"),
		Input = require("./Input"),
		Dropdown = require("./Dropdown"),
		Code = require("./Code"),
		Colorpicker = require("./Colorpicker"),
		Section = require("./Section"),
		Divider = require("./Divider"),
		Space = require("./Space"),
		Image = require("./Image"),
		Group = require("./Group"),
		HStack = require("./HStack"),
		VStack = require("./VStack"),
		--Video       = require("./Video"),
	},
	Load = function(tbl, Container, Elements, Window, WindUI, OnElementCreateFunction, ElementsModule, UIScale, Tab)
		local function DataSegment(value)
			local segment = tostring(value or "")
			segment = segment:gsub("[^%w]+", "_")
			segment = segment:gsub("^_+", ""):gsub("_+$", "")
			return segment
		end

		local function GetAutomaticDataKey(config, content)
			local tabTitle = Tab and Tab.Title or "Tab"
			local parentTitle = tbl ~= Tab and tbl.Title or nil
			local parts = { DataSegment(tabTitle) }
			if parentTitle then
				table.insert(parts, DataSegment(parentTitle))
			end
			table.insert(parts, DataSegment(content.__type))
			table.insert(parts, DataSegment(content.Title))

			local base = "__auto/" .. table.concat(parts, "/")
			local count = (Window.DataKeyCounts[base] or 0) + 1
			Window.DataKeyCounts[base] = count
			return count == 1 and base or base .. "_" .. tostring(count)
		end

		for name, module in next, Elements do
			tbl[name] = function(self, config)
				config = config or {}
				config.Tab = Tab or tbl
				config.ParentType = tbl.__type
				config.ParentTable = tbl
				config.Index = #tbl.Elements + 1
				config.GlobalIndex = #Window.AllElements + 1
				config.Parent = Container
				config.Window = Window
				config.WindUI = WindUI
				config.UIScale = UIScale
				config.ElementsModule = ElementsModule

				local elementInstance, content = module:New(config)
				local DataKey = config.Flag
				if not DataKey and Window.DataSave then
					DataKey = GetAutomaticDataKey(config, content)
					content.__dataKey = DataKey
				end

				if DataKey and typeof(DataKey) == "string" then
					if Window.CurrentConfig then
						Window.CurrentConfig:Register(DataKey, content)

						local PendingKey = DataKey
						if Window.PendingConfigData and not Window.PendingConfigData[PendingKey] and config.GlobalIndex then
							PendingKey = "__auto_" .. tostring(config.GlobalIndex) .. "_" .. tostring(content.__type)
						end
					if Window.PendingConfigData and Window.PendingConfigData[PendingKey] then
							local data = Window.PendingConfigData[PendingKey]

							local ConfigManager = Window.ConfigManager
							if ConfigManager.Parser[data.__type] then
								task.defer(function()
									local success, err = pcall(function()
										ConfigManager.Parser[data.__type].Load(content, data)
									end)

									if success then
										Window.PendingConfigData[PendingKey] = nil
									else
										warn(
											"[ WindUI ] Failed to apply pending config for '"
													.. DataKey
												.. "': "
												.. tostring(err)
										)
									end
								end)
							end
						end
					else
						Window.PendingFlags = Window.PendingFlags or {}
						Window.PendingFlags[DataKey] = content
					end
				end

				local frame
				for key, value in next, content do
					if typeof(value) == "table" and key ~= "ElementFrame" and key:match("Frame$") then
						frame = value
						break
					end
				end

				if frame then
					content.ElementFrame = frame.UIElements.Main
					function content:SetTitle(title)
						return frame.SetTitle and frame:SetTitle(title)
					end
					function content:SetDesc(desc)
						return frame.SetDesc and frame:SetDesc(desc)
					end
					function content:SetImage(image, size)
						return frame.SetImage and frame:SetImage(image, size)
					end
					function content:SetThumbnail(image, size)
						return frame.SetThumbnail and frame:SetThumbnail(image, size)
					end
					function content:Highlight()
						frame:Highlight()
					end
					function content:Destroy()
						frame:Destroy()

						table.remove(Window.AllElements, config.GlobalIndex)
						table.remove(tbl.Elements, config.Index)
						table.remove(Tab.Elements, config.Index)
						tbl:UpdateAllElementShapes(tbl)
					end
				end

				Window.AllElements[config.Index] = content
				tbl.Elements[config.Index] = content
				if Tab then
					Tab.Elements[config.Index] = content
				end

				if Window.NewElements then
					tbl:UpdateAllElementShapes(tbl)
				end

				if OnElementCreateFunction then
					OnElementCreateFunction(content, tbl.Elements)
				end
				return content
			end
		end
		function tbl:UpdateAllElementShapes(bbb)
			for i, element in next, bbb.Elements do
				local frame
				for key, value in pairs(element) do
					if typeof(value) == "table" and key:match("Frame$") then
						frame = value
						break
					end
				end

				if frame then
					--print("idx changed : " .. i .. " " .. (element.Title or "not found"))
					frame.Index = i
					if frame.UpdateShape then
						--print(" .changed: " .. i)
						frame.UpdateShape(bbb)
					end
				end
			end
		end
	end,
}
