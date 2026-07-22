import Foundation
import Testing
@testable import OpenIslandCore

struct CodexThreadVisibilityTests {
    @Test
    func appServerThreadDecodesAndHidesSubagentMetadata() throws {
        let data = Data(
            #"{"id":"guardian","cwd":"/tmp/project","name":null,"preview":"The following is the Codex agent history...","modelProvider":"openai","createdAt":1,"updatedAt":2,"ephemeral":false,"path":"/tmp/rollout.jsonl","status":{"type":"idle"},"source":"app-server","parentThreadId":"parent","threadSource":"subagent"}"#.utf8
        )

        let thread = try JSONDecoder().decode(CodexThread.self, from: data)

        #expect(thread.parentThreadId == "parent")
        #expect(thread.threadSource == "subagent")
        #expect(thread.isUserFacing == false)
    }

    @Test
    func appServerThreadKeepsTopLevelUserThreadVisible() throws {
        let data = Data(
            #"{"id":"user","cwd":"/tmp/project","name":"Fix island titles","preview":"让灵动岛显示具体任务名称。","modelProvider":"openai","createdAt":1,"updatedAt":2,"ephemeral":false,"path":"/tmp/rollout.jsonl","status":{"type":"active","activeFlags":[]},"source":"vscode","parentThreadId":null,"threadSource":"user"}"#.utf8
        )

        let thread = try JSONDecoder().decode(CodexThread.self, from: data)

        #expect(thread.isUserFacing)
    }
}
