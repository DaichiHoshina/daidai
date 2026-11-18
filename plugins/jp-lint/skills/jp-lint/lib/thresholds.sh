#!/usr/bin/env bash
# =============================================================================
# Canonical threshold definitions for ai-tools hooks.
# Edit here only. All hook / bats references must source this file.
# =============================================================================

# 多重 source 防止
if [[ "${_THRESHOLDS_LOADED:-}" == "1" ]]; then
    return 0
fi
_THRESHOLDS_LOADED=1

readonly _TH_PARALLEL_SEQ=2               # 並列 warn: sequential agent fire
readonly _TH_PARALLEL_SEQ_TTL_NS=600000000000 # 10 min。前回 fire からこれを超えて空いた起動は別作業とみなし、sequential counter を 0 から集計し直す (実測: 約 4 時間空いた別作業を逐次と集計して誤 warn した)
readonly _TH_BUNDLE_HARD_BLOCK_SEQ=3      # bundle 違反 hard block: warn 後の更なる sequential fire (bundle-violation guard)
readonly _TH_DELEGATE_SEQ=3               # 委譲 warn: large-repo 連続 edit
readonly _TH_PARALLEL_WINDOW_NS=30000000000 # 30 sec 並列判定 window (nanosec)。Claude Code は 1 message N tool_use を起動するとき subagent spawn の overhead で各 Agent 起動が 5-25 秒間隔になる実測あり (2026-06-25 bundle-violation-block.log elapsed_ms=23647)。500ms では並列を逐次扱いにして誤って block する。人間は 30 sec 以内に同じ command を連発しないため別 message 逐次の誤判定リスクは低い。
readonly _TH_TASK_COMPLETED_SEQ=2         # task 完了 warn
readonly _TH_STOP_MEMORY_FILES=3          # stop.sh save-memory 候補 file 数
readonly _TH_STOP_PUSH_MIN_TOOLS=3        # stop.sh 完了通知 guard: turn 内の tool 呼び出しがこの回数以上なら作業 turn とみなす
readonly _TH_STOP_PUSH_MIN_SEC=300        # stop.sh 完了通知 guard: turn の開始からこの秒数未満なら user が画面の前にいるとみなして判定しない (60 秒では 7 日で 110 件が terminal active で不要と判定された)
readonly _TH_LOG_ROTATION_LINES=1000      # subagent-start.sh log rotation
readonly _TH_LOG_MAX_BYTES=1048576        # 1MB、log rotation 閾値
readonly _TH_PROMPT_TRIGGER_THROTTLE_S=300 # 5 分。NG 語 pre-sweep と文書の執筆の trigger の inject を同じ間隔で抑える
readonly _TH_SUBAGENT_DUP_S=60             # 同じ identity の subagent をこの秒数以内に再起動したら重複起動として warn
readonly _TH_INJECT_SIZE_LOG_BYTES=1500    # 文体の注入がこの byte を超えたときだけ jp-quality-inject-size.log に記録する
readonly _TH_PARENT_PREP_MIN_WORDS=500     # subagent の prompt がこの語数以上のときだけ親の事前準備の不足を検査する (subagent context budget と一致)
readonly _TH_JP_REF_LIST_MAX=10           # block message に併記する語数の上限。比喩・擬人化 (block) は 435 語 2115 文字あり、全語を出力すると hit 語が埋没する (2026-09-14 実測)
